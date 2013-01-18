Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3ARRtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:49:15 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57250 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487Ab3ARRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:49:13 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18rLkkxpo5hOW5o9LMo6va4
Date: Fri, 18 Jan 2013 09:49:10 -0800
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Luciano Coelho <coelho@ti.com>, balbi@ti.com, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
Message-ID: <20130118174910.GF15361@atomide.com>
References: <20130117093417.GH10814@arwen.pp.htv.fi>
 <50F7CA82.4050509@ti.com>
 <20130117100510.GI10814@arwen.pp.htv.fi>
 <20130117100919.GJ10814@arwen.pp.htv.fi>
 <1358418917.6252.31.camel@cumari.coelho.fi>
 <50F7D535.6030205@ti.com>
 <20130117173131.GL14149@atomide.com>
 <1358445456.6252.64.camel@cumari.coelho.fi>
 <20130117231608.GP14149@atomide.com>
 <50F91FE2.3020402@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F91FE2.3020402@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [130118 02:15]:
> Hi Tony,
> 
> On 01/18/2013 12:16 AM, Tony Lindgren wrote:
> > Well we are planning to drop the non-DT support for omap4 as soon as it's
> > usable with DT.
> 
> Exactly, but right now we do have legacy and legacy should work in order to
> help for example Luca to make the final push which allows us to move to DT
> only for OMAP4.

Yeah I'm suggesting we should do the muxing in the platform code and fix the
regression in the driver. But not add the new platform callbacks.
 
> > For omap4 we are only carrying SDP and panda support to
> > make this transition easier. The only bindings missing AFAIK are wl12xx and
> > USB.
> >
> > If we add this, then it implies we're somehow supporting it, which is not
> > the way to go IMHO as we need to get rid of these platform callbacks instead.
> 
> IMHO we should keep these boards working as long as we have the legacy board
> support for them.

Naturally. We cannot flip over to DT only boot until we have usable system :)
And to me "usable system" means being able to use my pandaboard es with a lapdock
for work things.

Currently it seems that we need the following working with DT to have panda
and blaze usable:

1. MMC (done)
2. USB (patches pending for EHCI and MUSB)
3. Ethernet (done for blaze, needs USB for panda)
4. DSS (various drivers pending, probably still needs some platform init code)
5. WLAN (no binding, needs platform init until done)
6. Audio (done?)

The DMA binding is still pending, but these devices should also work without it
until we have the binding. And various miscellaneous drivers we can init with
the platform code until the bindings are done.

> So what is the policy now regarding to 'old' legacy but still used OMAP4 board
> files? I think we should still maintain them, but the effort to get rid of
> them should be the highest priority.

Yes only minimal fixes. We should not add any new features to them as that will
just complicate the conversion to DT. Once we have a usable system booting with DT,
we can ust drop the old omap4 board-*.c files.

Regards,

Tony
