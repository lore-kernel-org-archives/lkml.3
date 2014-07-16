Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbaGPMdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:33:39 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20670 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGPMdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:33:35 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+2Q6aI7QztR9ynsq+C3jsE
Date: Wed, 16 Jul 2014 05:32:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 6/6] tty: serial: Add 8250-core based omap driver
Message-ID: <20140716123208.GA18374@atomide.com>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
 <1404928177-26554-7-git-send-email-bigeasy@linutronix.de>
 <20140710070948.GH28884@atomide.com>
 <53BEB5AF.7010604@linutronix.de>
 <20140711064151.GJ28884@atomide.com>
 <53C66C0D.5060501@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C66C0D.5060501@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140716 05:14]:
> On 07/11/2014 08:41 AM, Tony Lindgren wrote:
> > 
> > If the RX pin does not wake it up, you need to configure the
> > pinctrl-single entry for it, and configure that pin as a wake-up
> > interrupt. See the interrupts-extended entry in omap3-beagle-xm.dts.
> 
> This does not help. Checking the manual, there is not something like
> PIN_OFF_WAKEUPENABLE for am33xx. There is just INPUT/OUTPUT, pull
> up/down + enabled/disabled and the mux_mode. For the interrupt, the HW
> referenced as omap3_pmx_core touches some bits in the pinmux register
> which do not exists on am33xx.

Right, on am33xx there's no IO chain wake-up path. AFAIK the only way
to provide wake events on am33xx would be to mux the RX pin temporarily
to a GPIO input. And sounds like that may work only if the GPIO is
in the first GPIO bank that's always on. I don't know if the other
GPIO banks on am33xx can provide wake up events.
 
> So I have nothing on HW around that could test wakeup scenario.

Bummer :( I'll give it a try again for the next revision.

Regards,

Tony
