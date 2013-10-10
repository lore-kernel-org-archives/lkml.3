Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab3JJQXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:23:20 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38120 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756160Ab3JJQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:23:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/cXvS1YIxoa1qx4SgNcuNt
Date: Thu, 10 Oct 2013 09:23:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: devicetree@vger.kernel.org, Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
Message-ID: <20131010162314.GD29913@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
 <20131003054221.8941.87801.stgit@localhost>
 <5256AA7F.8030005@ti.com>
 <20131010160018.GA29913@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010160018.GA29913@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [131010 09:09]:
> * Roger Quadros <rogerq@ti.com> [131010 06:32]:
> > 
> > I tried testing this with the USB EHCI driver, but I'm not getting wake up interrupts
> > while the system is still running and only the EHCI controller is runtime suspended.
> > 
> > It seems we need to somehow call _reconfigure_io_chain() to update the daisy chain
> > whenever the pad wakeup_enable bit is changed.
> 
> Sounds like this is on omap3? Have you tried calling pcs_soc->rearm() in the
> pcs_irq_handle() like the comments there suggest? At least for me that keeps
> the wake-up interrupts continuously running on omap3 instead of just idle modes.
> 
> Now on omap4, I've noticed the wake up interrupts are on all the time based on tests
> with the serial driver.

Oh, and if you're runtime suspending EHCI only, and if the EHCI module has
wake-up registers, it should be able to wake EHCI from retention on it's own
without a need for the io chain at all.

At least the serial driver does that if it's internal wake-up registers are
configured right. But for off-idle, the serial driver needs the io chain wake-up
events.

Regards,

Tony
