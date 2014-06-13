Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaFMNKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:10:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30613 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751321AbaFMNKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:10:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Ik6eSjZAnowpvXkWEbQPYPHFTrUn2LTw=
X-DKIM: OpenDKIM Filter v2.0.1 titan C4E9458EBE6
Date: Fri, 13 Jun 2014 09:10:05 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, nm@ti.com,
        rnayak@ti.com, linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 03/19] irqchip: crossbar: Skip some irqs from
 getting mapped to crossbar
Message-ID: <20140613131005.GF8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-4-git-send-email-r.sricharan@ti.com>
 <20140612125134.GS8664@titan.lakedaemon.net>
 <20140612135715.GE17845@atomide.com>
 <20140612140508.GC8664@titan.lakedaemon.net>
 <539AA08A.7010001@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539AA08A.7010001@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:26:10PM +0530, Sricharan R wrote:
> On Thursday 12 June 2014 07:35 PM, Jason Cooper wrote:
...
> > Do you have other changes outside of irqchip depending on this series?
> > If so, I can set up a topic branch for you guys to base off of.
> > Otherwise, I'll just apply them to irqchip/core when they're ready.
> > 
>  There are dts changes which are dependent upon this series.
> 
>   http://www.spinics.net/lists/linux-omap/msg108116.html

In general, dts changes shouldn't depend on code changes or vice-versa.
If they do, that's an indicator that we're breaking compatibility with
older dtbs.

Looking at the dra7.dtsi changes, we're redefining the interrupt
property, which can't be good. :(

Perhaps a better solution would be to add a property, say 'ti,cross-irq'
that is the exact same format as 'interrupts', but is used by the
crossbar driver?

I'm not convinced of this yet, I suspect we may not actually have a
dependency between the dtsi changes and the code changes.  We would have
the ugly "if you have the crossbar node, 'interrupts' means X, if not it
means Y" in the binding docs.  But the absence of the node prevents the
crossbar driver from re-interpreting the interrupts property.

Have you tried booting all the different scenarios?  eg:

  old dtb, new driver
  new dtb, old driver
  old dtb, old driver
  new dtb, new driver

thx,

Jason.
