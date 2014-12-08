Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaLHTpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:45:30 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:57043 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaLHTpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:45:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,540,1413270000"; 
   d="scan'208";a="52714124"
Message-ID: <5485FFCE.9000009@broadcom.com>
Date: Mon, 8 Dec 2014 11:45:18 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        "Scott Branden" <sbranden@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <bcm-kernel-feedback-list@broadcom.com>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] gpio: Cygnus: define Broadcom Cygnus GPIO binding
References: <1418064468-8512-3-git-send-email-rjui@broadcom.com> <2129851.JzMQjVqeL2@wuerfel>
In-Reply-To: <2129851.JzMQjVqeL2@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/8/2014 11:38 AM, Arnd Bergmann wrote:
> On Monday 08 December 2014 10:47:44 Ray Jui wrote:
>> +
>> +- no-drv-stregnth:
>> +    Specifies the GPIO controller does not support drive strength configuration
>> +
>>
>
> Typo:
>
> 	strength, not stregnth
>
> Otherwise looks good.
>
> 	Arnd
>
Right...Let me fix that. Also noticed the following in the device tree 
binding example that needs to be fixed:
	gpio_crmu: gpio@03024800 {

		compatible = "brcm,cygnus-crmu-gpio";
The above line needs to be fixed with:
		compatible = "brcm,cygnus-gpio";

		reg = <0x03024800 0x50>;
		ngpios = <6>;
		#gpio-cells = <2>;
		gpio-controller;
		no-drv-stregnth;
	};
