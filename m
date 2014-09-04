Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaIDQZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:25:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55208 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaIDQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:25:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18zwv4nZA5yaRYRmUZJapOM
Date: Thu, 4 Sep 2014 09:25:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
Message-ID: <20140904162542.GS11766@atomide.com>
References: <540048B4.7010807@linutronix.de>
 <20140829161221.GO16006@atomide.com>
 <5404B149.6010400@linutronix.de>
 <54060EDA.6060204@linutronix.de>
 <20140902201536.GC11766@atomide.com>
 <540745CC.2090901@linutronix.de>
 <20140903174845.GE11766@atomide.com>
 <54086CA7.8020507@linutronix.de>
 <20140904145203.GR11766@atomide.com>
 <54087D94.7000208@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54087D94.7000208@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140904 07:56]:
> On 09/04/2014 04:52 PM, Tony Lindgren wrote:
> > Yeah makes sense to me. Thanks for ensuring the bug
> > compability :)
> 
> Thanks. What about the ttyOx vs ttySx. Do you want me to add kernel
> line fixup somewhere arch/arm or we ignore this for now? Greg didn't
> say anything…

I suggest we have both drivers just available first and then attempt
to deal with the removal of most of omap-serial later on.

If both drivers are present, we should try to ensure 8250 gets probed
first which I believe it already does based on the Makefile order.

Once the 8250 based driver is known to work, it might make sense to
remove most of the functions in omap-serial and have it use the 8250
functions too to remove duplicate code.

That might be already enough and no proxying is needed and we get
rid of the duplicate code :)

Regards,

Tony
