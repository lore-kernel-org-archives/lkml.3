Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3K0NI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:08:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39505 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3K0NIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:08:54 -0500
Message-ID: <5295EE7B.6030504@ti.com>
Date: Wed, 27 Nov 2013 18:37:07 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
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
References: <5291CB01.1010506@ti.com> <1385409654-19006-1-git-send-email-ivan.khoronzhuk@ti.com> <5295AECB.7040503@ti.com> <5295D102.2010101@ti.com>
In-Reply-To: <5295D102.2010101@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 November 2013 04:31 PM, ivan.khoronzhuk wrote:
>>> @@ -192,9 +193,15 @@ static __init void davinci_ntosd2_init(void)
>>>           davinci_cfg_reg(DM644X_ATAEN_DISABLE);
>>>
>>>           /* only one device will be jumpered and detected */
>>> -        if (HAS_NAND)
>>> +        if (HAS_NAND) {
>>>               platform_device_register(
>>>                       &davinci_ntosd2_nandflash_device);
>>> +
>>> +            if (davinci_aemif_setup(
>>> +                &davinci_ntosd2_nandflash_device))
>>> +                pr_warn("%s: Cannot configure AEMIF.\n",
>>> +                    __func__);
>>
>> This is looking really ugly. Can you shorten
>> davinci_ntosd2_nandflash_device to just "ntosd2_nandflash" or similar?
> 
> The rename is not related to the patch, so I won't do this.

The reason I asked you to rename is not because I want to push some
random clean-up into this patch. You had to introduce a line so broken
that its almost unreadable. I offered the suggestion as a way to improve
the readability of the code you are introducing in *this* patch.

Thanks,
Sekhar
