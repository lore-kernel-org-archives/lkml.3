Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3G2OfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:35:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39293 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab3G2OfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:35:02 -0400
Message-ID: <51F67D7D.9070003@ti.com>
Date: Mon, 29 Jul 2013 09:34:37 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benoit Cousson <benoit.cousson@gmail.com>
CC: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, J Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH 0/9] ARM: dts: omap5-uevm: fixup wrong regulator configuration
References: <1374079538-19548-1-git-send-email-nm@ti.com> <51F63C74.6070503@ti.com> <51F66B65.4030702@ti.com> <51F670AF.9080808@gmail.com> <51F67875.9020602@ti.com> <CADz42=M8LQ=i2q30=JJU+F-Qx89D1PwU7pW3DH7F1iYiC8-pFA@mail.gmail.com>
In-Reply-To: <CADz42=M8LQ=i2q30=JJU+F-Qx89D1PwU7pW3DH7F1iYiC8-pFA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 09:19 AM, Benoit Cousson wrote:
> 2013/7/29 Nishanth Menon <nm@ti.com <mailto:nm@ti.com>>
>
> Well you're lucky I'm now in an area with Wifi and 3G access... last
> week it whould have been impossible to receive it :-)
hehe :)

>
>> All the "fixes" are sharing more than 50% of the changelog
>> content with
>> only 2 changes in the code, so you'd better squash them into one
>> patch
>> to avoid repeating the same thing again and again.
>
>> Reason for keeping them separate was to allow any future git bisect
>> to narrow down to precise patch.
>>     <--->
> Mmm, why? Do you expect some settings to not work or generate crash?

It has worked with a backport to full fledged OS on top and I do not 
expect it to fail, however, I am never sure about how the future issues 
look like :)

>       ARM: dts: omap5-uevm: update SMPS9 settings
>        ARM: dts: omap5-uevm: update and disable unused regulators LDO[28]
>        ARM: dts: omap5-uevm: update LDO1 voltage to 1.5V and settings
>        ARM: dts: omap5-uevm: update LDO3 voltage to 1.5V and settings
>        ARM: dts: omap5-uevm: update LDO4 voltage to 1.5V and settings
>        ARM: dts: omap5-uevm: update LDO6 voltage to 1.2V
>        ARM: dts: omap5-uevm: update LDO7 voltage to 2V and settings
>        ARM: dts: omap5-uevm: update SDCARD LDO9 and resource REGEN3
>     <---->
>
>     Would you have suggestions on what to squash up?
>
>
>
> I guess one patch for all the mandatory fixes, and another one with the
> improvements should be good enough.
>
> Does that sounds OK to you?

patch #1 ARM: dts: omap5-uevm: document regulator signals used on the 
actual board
   -> as is, since it is a documentation patch
Patch #2: ARM: dts: omap5-uevm: fix regulator configurations mandatory 
for SoC
squash of:
-> ARM: dts: omap5-uevm: update LDO1 voltage to 1.5V and settings
-> ARM: dts: omap5-uevm: update LDO3 voltage to 1.5V and settings
-> ARM: dts: omap5-uevm: update LDO4 voltage to 1.5V and settings
-> ARM: dts: omap5-uevm: update LDO6 voltage to 1.2V
-> ARM: dts: omap5-uevm: update LDO7 voltage to 2V and settings
-> ARM: dts: omap5-uevm: update SDCARD LDO9 and resource REGEN3

Patch #3: ARM: dts: omap5-uevm: update optional regulator configurations
squash of:
  -> ARM: dts: omap5-uevm: update SMPS9 settings
  -> ARM: dts: omap5-uevm: update and disable unused regulators LDO[28]

Does that sound fine?
-- 
Regards,
Nishanth Menon
