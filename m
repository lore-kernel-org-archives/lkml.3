Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965246AbaGRKLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:11:53 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:63126 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026AbaGRKLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:11:49 -0400
MIME-Version: 1.0
In-Reply-To: <6186153.TIYp5NXPIq@wuerfel>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
 <1405663186-26464-2-git-send-email-cw00.choi@samsung.com> <6186153.TIYp5NXPIq@wuerfel>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 18 Jul 2014 15:41:27 +0530
Message-ID: <CAHfPSqBDOEH5HurG=rECV=d+MM_YjTEpsiwuTgtNgFgCQ0P2bw@mail.gmail.com>
Subject: Re: [PATCHv6 1/4] iio: adc: exynos_adc: Add exynos_adc_data structure
 to improve readability
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        My self <ch.naveen@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On 18 July 2014 15:12, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 July 2014 14:59:43 Chanwoo Choi wrote:
>> This patchset add 'exynos_adc_data' structure which includes some functions
>> to control ADC operation and specific data according to ADC version (v1 or v2).
>>
>
> This new structure makes a lot of sense for covering the exynos specific
> versions, but it will likely give a little more complexity for the
> older models. We'll have to deal with that later then, no need to
> hold up your patch. Interestingly, the version numbers seem weird. The
> old driver uses
>
>         {
>                 .name           = "s3c24xx-adc",
>                 .driver_data    = TYPE_ADCV1,
>         }, {
>                 .name           = "s3c2443-adc",
>                 .driver_data    = TYPE_ADCV11,
>         }, {
>                 .name           = "s3c2416-adc",
>                 .driver_data    = TYPE_ADCV12,
>         }, {
>                 .name           = "s3c64xx-adc",
>                 .driver_data    = TYPE_ADCV2,
>         }, {
>                 .name           = "samsung-adc-v3",
>                 .driver_data    = TYPE_ADCV3,
>         }
>
> Where TYPE_ADCV3 seems to be the same as the new ADC_V1 used in this
> driver. Do you have an explanation for that?

As per suggestion from Doug Anderson,
I've implemented IIO based ADC driver to work with Exynos5250.
keeping the plat-samsung/adc.c unchanged.

Assuming Exynos5250 is the one using the driver for the first time.
i've named it v1 and so on.

Now, This seems to cause a lot of confusion.

>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shine bright,
(: Nav :)
