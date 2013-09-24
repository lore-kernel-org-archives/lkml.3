Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3IXP6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:58:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49705 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3IXP6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:58:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JqhGxlkzUTY/nGo5tl+eL
Date: Tue, 24 Sep 2013 08:58:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Balaji T K <balajitk@ti.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, r.sricharan@ti.com, holler@ahsoftware.de
Subject: Re: [RFC v2] gpio/omap: auto-setup a GPIO when used as an IRQ
Message-ID: <20130924155808.GP2684@atomide.com>
References: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk>
 <20130924154048.GM2684@atomide.com>
 <5241B3B7.5070701@ti.com>
 <5241B465.5050604@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5241B465.5050604@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [130924 08:56]:
> On Tuesday 24 September 2013 11:45 AM, Balaji T K wrote:
> > On Tuesday 24 September 2013 09:10 PM, Tony Lindgren wrote:
> >> * Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130924 01:06]:
> >>> The OMAP GPIO controller HW requires a pin to be configured in GPIO
> >>> input mode in order to operate as an interrupt input. Since drivers
> >>> should not be aware of whether an interrupt pin is also a GPIO or not,
> >>> the HW should be fully configured/enabled as an IRQ if a driver solely
> >>> uses IRQ APIs such as request_irq(), and never calls any GPIO-related
> >>> APIs. As such, add the missing HW setup to the OMAP GPIO controller's
> >>> irq_chip driver.
> >>>
> >>> Since this bypasses the GPIO subsystem we have to ensure that another
> >>> caller won't be able to request the same GPIO pin that is used as an
> >>> IRQ and set its direction as output. Requesting the GPIO and setting
> >>> its direction as input is allowed though.
> >>
> >> Also please mention the regression that this fixes. So far we know
> >> that smsc911x for tobi and igep boards in mainline, and also the
> > 
> >> MMC card detect for omap4 boards.
> > Hi Tony,
> > 
> > Card detect on omap4 board (sdp and panda) is not based on omap gpio,
> > so I think this fix is not applicable for omap4.
> > 
> > Card detect line for SD card goes to power IC on OMAP4 panda and SDP.
> > 
> I confused Tony mostly. It was OMAP4 SPI based ethernet which uses the
> GPIO as an interrupt line.
> 
> So for Panda, its Ethernet driver and not MMC.

OK :) Thanks for clarifying.

Tony
