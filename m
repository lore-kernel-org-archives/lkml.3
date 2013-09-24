Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3IXPtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:49:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55955 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3IXPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:49:20 -0400
Message-ID: <5241B465.5050604@ti.com>
Date: Tue, 24 Sep 2013 11:48:53 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Balaji T K <balajitk@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
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
        Jon Hunter <jgchunter@gmail.com>, <linux-gpio@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <r.sricharan@ti.com>,
        <holler@ahsoftware.de>
Subject: Re: [RFC v2] gpio/omap: auto-setup a GPIO when used as an IRQ
References: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk> <20130924154048.GM2684@atomide.com> <5241B3B7.5070701@ti.com>
In-Reply-To: <5241B3B7.5070701@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 September 2013 11:45 AM, Balaji T K wrote:
> On Tuesday 24 September 2013 09:10 PM, Tony Lindgren wrote:
>> * Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130924 01:06]:
>>> The OMAP GPIO controller HW requires a pin to be configured in GPIO
>>> input mode in order to operate as an interrupt input. Since drivers
>>> should not be aware of whether an interrupt pin is also a GPIO or not,
>>> the HW should be fully configured/enabled as an IRQ if a driver solely
>>> uses IRQ APIs such as request_irq(), and never calls any GPIO-related
>>> APIs. As such, add the missing HW setup to the OMAP GPIO controller's
>>> irq_chip driver.
>>>
>>> Since this bypasses the GPIO subsystem we have to ensure that another
>>> caller won't be able to request the same GPIO pin that is used as an
>>> IRQ and set its direction as output. Requesting the GPIO and setting
>>> its direction as input is allowed though.
>>
>> Also please mention the regression that this fixes. So far we know
>> that smsc911x for tobi and igep boards in mainline, and also the
> 
>> MMC card detect for omap4 boards.
> Hi Tony,
> 
> Card detect on omap4 board (sdp and panda) is not based on omap gpio,
> so I think this fix is not applicable for omap4.
> 
> Card detect line for SD card goes to power IC on OMAP4 panda and SDP.
> 
I confused Tony mostly. It was OMAP4 SPI based ethernet which uses the
GPIO as an interrupt line.

So for Panda, its Ethernet driver and not MMC.

Regards,
Santosh

