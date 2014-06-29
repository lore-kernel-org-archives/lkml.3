Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaF2LsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 07:48:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:53607 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaF2LsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 07:48:02 -0400
Message-ID: <53AFFD69.8060702@kernel.org>
Date: Sun, 29 Jun 2014 12:50:01 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, ch.naveen@samsung.com,
        t.figa@samsung.com, kgene.kim@samsung.com
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv5 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and
 code clean
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/14 05:30, Chanwoo Choi wrote:
> Changes from v4:
> - Use 'exynos_adc_data' structure instead of 'exynos_adc_ops' structure
>    and remove enum variable of ADC version
> - Fix wrong name of special clock (sclk_tsadc -> sclk_adc)
> - Add reviewed message by Naveen Krishna Chatradhi
> - Add functions for ADC clock control
>
> Changes from v3:
> - Add new 'exynos_adc_ops' structure to improve readability according to
>   Tomasz Figa comment[1]
>   [1] https://lkml.org/lkml/2014/4/16/238
> - Add new 'exynos3250-adc-v2' compatible string to support Exynos3250 ADC
> - Fix wrong compaitlbe string of ADC in Exynos3250 dtsi file
>
> Changes from v2:
> - Check return value of clock function to deal with error exception
> - Fix minor coding style to improve readability
>
> Changes from v1:
> - Add new "samsung,exynos-adc-v3" compatible to support Exynos3250 ADC
> - Add a patch about DT binding documentation
>
> Chanwoo Choi (4):
>    iio: adc: exynos_adc: Add exynos_adc_data structure to improve readability
>    iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
>    iio: devicetree: Add DT binding documentation for Exynos3250 ADC
>    ARM: dts: Fix wrong compatible string for Exynos3250 ADC
>
>   .../devicetree/bindings/arm/samsung/exynos-adc.txt |  26 +-
>   arch/arm/boot/dts/exynos3250.dtsi                  |   4 +-
>   drivers/iio/adc/exynos_adc.c                       | 326 +++++++++++++++------
>   3 files changed, 268 insertions(+), 88 deletions(-)
>
I am happy with this series, but given it touches some exynos bindings, I would
like an ack from Kukjin Kim (or according to MAINTAINERS Ben Dooks) before taking it
all through IIO.

Thanks,

Jonathan
