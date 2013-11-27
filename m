Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3K0NXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:23:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43760 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3K0NX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:23:28 -0500
Message-ID: <5295F1EB.7030804@ti.com>
Date: Wed, 27 Nov 2013 15:21:47 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <rob@landley.net>, <linux@arm.linux.org.uk>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <galak@kernel.crashing.org>,
        <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] ARM: davinci: aemif: get rid of davinci-nand driver dependency
 on aemif
References: <5291CB01.1010506@ti.com> <1385409654-19006-1-git-send-email-ivan.khoronzhuk@ti.com> <5295AECB.7040503@ti.com> <5295D102.2010101@ti.com> <5295EE7B.6030504@ti.com>
In-Reply-To: <5295EE7B.6030504@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 03:07 PM, Sekhar Nori wrote:
> On Wednesday 27 November 2013 04:31 PM, ivan.khoronzhuk wrote:
>>>> @@ -192,9 +193,15 @@ static __init void davinci_ntosd2_init(void)
>>>>            davinci_cfg_reg(DM644X_ATAEN_DISABLE);
>>>>
>>>>            /* only one device will be jumpered and detected */
>>>> -        if (HAS_NAND)
>>>> +        if (HAS_NAND) {
>>>>                platform_device_register(
>>>>                        &davinci_ntosd2_nandflash_device);
>>>> +
>>>> +            if (davinci_aemif_setup(
>>>> +                &davinci_ntosd2_nandflash_device))
>>>> +                pr_warn("%s: Cannot configure AEMIF.\n",
>>>> +                    __func__);
>>>
>>> This is looking really ugly. Can you shorten
>>> davinci_ntosd2_nandflash_device to just "ntosd2_nandflash" or similar?
>>
>> The rename is not related to the patch, so I won't do this.
>
> The reason I asked you to rename is not because I want to push some
> random clean-up into this patch. You had to introduce a line so broken
> that its almost unreadable. I offered the suggestion as a way to improve
> the readability of the code you are introducing in *this* patch.
>
> Thanks,
> Sekhar
>

Ok, I will rename

-- 
Regards,
Ivan Khoronzhuk
