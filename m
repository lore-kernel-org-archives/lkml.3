Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422701AbaGRRCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:02:17 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50848 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030432AbaGRRCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:02:11 -0400
MIME-Version: 1.0
In-Reply-To: <5835825.JtcDoyOP8b@wuerfel>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
	<6104032.PNRl85V92G@wuerfel>
	<CAGTfZH3cH-QFMbfTWJJfTPTRT-Bij2TW=6CH_Yy-GaZqZvn-Xg@mail.gmail.com>
	<5835825.JtcDoyOP8b@wuerfel>
Date: Sat, 19 Jul 2014 02:02:09 +0900
Message-ID: <CAGTfZH3mnPJ72wi7aFYoChe_OeuRVsUVo3KGRRLTV5scwPbO4g@mail.gmail.com>
Subject: Re: [PATCHv6 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        naveen krishna <ch.naveen@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        rdunlap@infradead.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 1:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 19 July 2014 01:23:15 Chanwoo Choi wrote:
>> If don't add new compatible including specific exynos version,
>> I would add new 'adc-needs-sclk' property with existing 'exynos-adc-v2'
>> compatible name.
>>
>>
>> Dear Naveen, Tomasz,
>>
>> If existing exynos-adc driver add just one property for 'sclk_adc'
>> as following, exynos-adc could not include the exynos version
>> in compatible name.
>>
>> I need your opinion about it.
>>
>>                 adc: adc@126C0000 {
>>                         compatible = "samsung,exynos-adc-v2";
>>                         reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>>                         interrupts = <0 137 0>;
>>                         clock-names = "adc", "sclk_adc";
>>                         clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
>> +                        adc-needs-sclk;
>>                         #io-channel-cells = <1>;
>>                         io-channel-ranges;
>>                 }
>
> How about just making it an optional clock? That would be much
> easier because then you can simply see if the clock itself is
> there and use it, or otherwise ignore it.

The v1 of this patchset[1] got the clock of 'sclk_adc'  but if the dt node
of ADC in dtsi file didn't include 'sclk_adc', print just warning message
without stopping probe as following:

 [1] https://lkml.org/lkml/2014/4/10/710

+       info->sclk = devm_clk_get(&pdev->dev, "sclk_adc");
+       if (IS_ERR(info->sclk)) {
+               dev_warn(&pdev->dev, "failed getting sclk clock, err = %ld\n",
+                                                       PTR_ERR(info->sclk));
+               info->sclk = NULL;
+       }

But, Tomasz Figa suggested the method[2] of this patchset(v6).
 [2] https://lkml.org/lkml/2014/4/11/189

Thanks,
Chanwoo Choi
