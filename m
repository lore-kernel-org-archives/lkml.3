Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaHMQha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:37:30 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39044 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090AbaHMQh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:37:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX193iKIt/2pawD6KinhfqDXS
Date: Wed, 13 Aug 2014 09:37:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] tty: serial: Add 8250-core based omap driver
Message-ID: <20140813163722.GA9239@atomide.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-6-git-send-email-bigeasy@linutronix.de>
 <20140717070859.GD18374@atomide.com>
 <20140717074219.GA29193@linutronix.de>
 <20140717081232.GH18374@atomide.com>
 <53C7A01C.50107@linutronix.de>
 <20140718062456.GJ18374@atomide.com>
 <20140721093528.GS18374@atomide.com>
 <53EB9066.3060208@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EB9066.3060208@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140813 09:23]:
> On 07/21/2014 11:35 AM, Tony Lindgren wrote:
> 
> > Looks like the following is needed to avoid the error, no idea why..
> > But this is what we also do in omap-serial.c. It may be needed in
> > other places too?
> 
> Yes, there was a third one on shutdown.

OK
 
> > Also, no luck yet on runtime PM. If the console is enabled omap won't
> > idle, and if no serial console is enabled, it just hangs. Will try
> > to debug this part further, it may be also related to the above.
> 
> My beaglebone xm won't do idle:
> 
> | omap3_pm_off_mode_enable: Core OFF disabled due to errata i583
> 
> but it would if it could, right? That means that I can't test the wake
> via UART on this one?

Hmm OK yes that's disabled for some earlier ES revisions. I guess you
could comment out the limitations for PM_SDRC_WAKEUP_ERRATUM_i583
in both cpuidle34xx.c and pm34xx.c and see if off-idle is usable for
your tests :) It might be flakey but still usable for testing.
 
> So I will try to fix the tx-pm, fold patches and then prepare another
> batch.

OK great, let me know if you need more help.

> And I could verify that DMA works on that omap3 :)

OK

Regards,

Tony
