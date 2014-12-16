Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaLPAIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:08:45 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8884 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaLPAIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:08:43 -0500
X-IronPort-AV: E=Sophos;i="5.07,582,1413270000"; 
   d="scan'208";a="52987669"
Message-ID: <548F7809.1020303@broadcom.com>
Date: Mon, 15 Dec 2014 16:08:41 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Alexandre Courbot <gnurou@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Joe Perches <joe@perches.com>,
        Rob Herring <robh+dt@kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v5 1/3] gpio: Cygnus: define Broadcom Cygnus GPIO binding
References: <1418342706-14755-2-git-send-email-rjui@broadcom.com> <1628217.66frkAqHMc@wuerfel> <548F5433.5090901@broadcom.com> <2063145.N1Hk6vVF2S@wuerfel>
In-Reply-To: <2063145.N1Hk6vVF2S@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/15/2014 1:57 PM, Arnd Bergmann wrote:
> On Monday 15 December 2014 13:35:47 Ray Jui wrote:
>>
>> Like I said previously, dynamic GPIO allocation works fine in the
>> kernel, as long as all of our GPIO clients in the kernel use gpiod based
>> API, which is what we will enforce going forward. The only problem is
>> with some of our customers who use GPIO through sysfs and expect fixed
>> global GPIO numbers. Thinking about this more, it's probably not that
>> difficult to add a script for those customers to convert/map the GPIO
>> numbers based on readings parsed from sysfs, so I guess that's fine.
>>
>
> I think we discussed the user space interface a number of times
> in the past, but I forgot the outcome. Either there is already
> a way to name gpio lines uniquely in sysfs, or there should be
> one.
>
> Can you reach the gpio interfaces using /sys/devices/0001234.bus/1234566.gpiocontroller/...?
>
> 	Arnd
>
We use entries under /sys/class/gpio/ to control GPIOs. All base, label, 
and ngpio info specific to a GPIO controller can be found there.
