Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaLHQz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:55:26 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45983 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbaLHQzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:55:22 -0500
X-IronPort-AV: E=Sophos;i="5.07,539,1413270000"; 
   d="scan'208";a="52372409"
Message-ID: <5485D7F8.6090305@broadcom.com>
Date: Mon, 8 Dec 2014 08:55:20 -0800
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
Subject: Re: [PATCH v2 1/5] gpio: Cygnus: define Broadcom Cygnus GPIO binding
References: <1418006316-324-2-git-send-email-rjui@broadcom.com> <2594176.SCRFa6Sb3O@wuerfel>
In-Reply-To: <2594176.SCRFa6Sb3O@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/8/2014 3:22 AM, Arnd Bergmann wrote:
> On Sunday 07 December 2014 18:38:32 Ray Jui wrote:
>> +Required properties:
>> +
>> +- compatible:
>> +    Currently supported Cygnus GPIO controllers include:
>> +    "brcm,cygnus-ccm-gpio": ChipcommonG GPIO controller
>> +    "brcm,cygnus-asiu-gpio": ASIU GPIO controller
>> +    "brcm,cygnus-crmu-gpio": CRMU GPIO controller
>
> How different are these? If they are almost the same, would it
> be better to use the same compatible string for all of them and
> describe the differences in extra properties?
>
> If they are rather different, maybe you should have a separate
> binding and driver for each?
>
> 	Arnd
>
They are quite similar with the following minor differences:
1) ChipcommonG GPIO controller uses a separate register block 
(0x0301d164) to control drive stregnth
2) Cannot control drive strength for the CMRU GPIO
3) CRMU GPIO controller's interrupt is not connected to GIC of A9. 
Currently that's taken care of by using a "no-interrupt" device tree 
property

I can change to use the common compatible string "brcm,cygnus-gpio". 
With an introduction of property "no-drv-stregnth" which should be set 
for CRMU GPIO controller. For ChipcommonG GPIO, it will have a second 
register block defined, so we'll know to use that second register block 
for drive strength configuration. For the rest, we assume normal drive 
strength configuration (i.e., ASIU in our case).

Looking at this again, it looks like the "no-interrupt" property is 
really redundant. For GPIO controller without interrupt connected to A9, 
we can simply leave its interrupt properties not defined. I'll get rid 
of it along with the above changes.
