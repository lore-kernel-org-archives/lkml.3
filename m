Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254AbaGRKNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:13:45 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:41535 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679AbaGRKNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:13:41 -0400
MIME-Version: 1.0
In-Reply-To: <59765980.V0Hsx6tyKd@wuerfel>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <59765980.V0Hsx6tyKd@wuerfel>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 18 Jul 2014 15:43:18 +0530
Message-ID: <CAHfPSqBiDZXxSVaK3PHrGhDQxi4TU=szKA06Odm9yeB8a5rDFw@mail.gmail.com>
Subject: Re: [PATCHv6 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and
 code clean
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        My self <ch.naveen@samsung.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        linux-iio@vger.kernel.org, t.figa@samsung.com, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On 18 July 2014 15:08, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 July 2014 14:59:42 Chanwoo Choi wrote:
>> This patchset support Exynos3250 ADC (Analog Digital Converter) because
>> Exynos3250 has additional special clock for ADC IP.
>>
>
> by coincidence, I have just looked at the same driver in order to
> add support for s3c24xx and s3c64xx, so we can remove the plat-samsung
> adc framework they still use.  Those changes would naturally conflict
> with yours, but I think it makes sense for your patches to come first.
>
> I'll comment a bit more on the individual patches. I didn't have
> interest in them earlier, so I didn't comment so far.
>
> Another aspect that came up is the touchscreen support. Right now,
> there is drivers/input/touchscreen/s3c2410_ts.c which is intimately
> tied to arch/arm/plat-samsung/adc.c. The best way forward (as discussed
> on IRC as few days ago) seems to be to integrate support for that into
> the exynos_adc driver. Can you comment on which parts actually support
> touchscreen? Did touchscreen support get dropped in the exynos hardware,
> or is the driver just missing at the moment?

SoCs from Samsung before Exynos4 had and ADC based Touch screen
and the driver under arch/arm/plat-samsung/adc.c and
drivers/input/touchscreen/s3c2410_ts.c used to work together.

Infact, the interrupt routine and priorities in plat-samsung/adc.c
driver as written keeping the Touchscreen in mind.

After Exynos4, ADC IP remained. But, the touch screen was removed in hardware.

As per suggestion from Doug Anderson, I've implemented IIO based ADC
driver started to support from exynos5250.

>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shine bright,
(: Nav :)
