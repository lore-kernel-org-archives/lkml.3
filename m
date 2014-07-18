Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934932AbaGRQXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:23:19 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64617 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaGRQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:23:17 -0400
MIME-Version: 1.0
In-Reply-To: <6104032.PNRl85V92G@wuerfel>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
	<1405663186-26464-4-git-send-email-cw00.choi@samsung.com>
	<6104032.PNRl85V92G@wuerfel>
Date: Sat, 19 Jul 2014 01:23:15 +0900
Message-ID: <CAGTfZH3cH-QFMbfTWJJfTPTRT-Bij2TW=6CH_Yy-GaZqZvn-Xg@mail.gmail.com>
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

On Fri, Jul 18, 2014 at 6:50 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 July 2014 14:59:45 Chanwoo Choi wrote:
>>                         Must be "samsung,exynos-adc-v2" for
>>                                 future controllers.
>
> It would be good to change 'future controllers' to something else now.
> Presumably that word was used before the actual products were announced,
> but now they are publically known.
>
>> +                       Must be "samsung,exynos3250-adc-v2" for
>> +                               controllers compatible with ADC of Exynos3250.
>
> Doesn't this version have a specific name as well? The ADC block
> seems to use version numbers, so better put those in here to avoid
> confusion when another Exynos7890 comes out that uses the same
> ADC as exynos3250.

If don't add new compatible including specific exynos version,
I would add new 'adc-needs-sclk' property with existing 'exynos-adc-v2'
compatible name.


Dear Naveen, Tomasz,

If existing exynos-adc driver add just one property for 'sclk_adc'
as following, exynos-adc could not include the exynos version
in compatible name.

I need your opinion about it.

                adc: adc@126C0000 {
                        compatible = "samsung,exynos-adc-v2";
                        reg = <0x126C0000 0x100>, <0x10020718 0x4>;
                        interrupts = <0 137 0>;
                        clock-names = "adc", "sclk_adc";
                        clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
+                        adc-needs-sclk;
                        #io-channel-cells = <1>;
                        io-channel-ranges;
                }

Thanks,
Chanwoo Choi
