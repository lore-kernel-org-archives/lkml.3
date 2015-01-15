Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbbAOPZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:25:42 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:60597 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbbAOPZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:25:40 -0500
MIME-Version: 1.0
In-Reply-To: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
References: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
From: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Date: Thu, 15 Jan 2015 16:25:19 +0100
X-Google-Sender-Auth: kNSnUSkCl0OdkUjj1qEYbSdGJCA
Message-ID: <CAAObsKCUed_-XndZC_-mn_MWt5f2h0OUff_FHC30W4+2VQxsQg@mail.gmail.com>
Subject: Re: [RFC 0/3] mmc: Add dynamic frequency scaling
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 January 2015 at 10:23, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> Hi,
>
>
> I would like to hear some comments about idea of scaling MMC clock
> frequency. The basic idea is to lower the clock when device is
> completely idle or not busy enough.
>
> The patchset adds MMC card as a devfreq device and uses simple_ondemand
> as governor. In idle this gave benefits (less energy consumed during
> idle):
> 1. Trats2 (Exynos4412): 2.6%
> 2. Rinato (Exynos3250): 1%
>
> but (especially on Rinato) it had impact on performance (probably
> because ondemand triggering a little to late). What is interesting
> manually changing the clock (without this patchset) gave slightly
> bigger benefits. Maybe the devfreq introduces noticeable overhead?

Could it be because of the polling interval being too long thus it
being too slow to ramp up?

That's a problem with all polling devfreq drivers, it has been
proposed before using pm_qos to to reduce the polling interval when
some event indicates that the utilization may grow abruptly in the
near future.

I don't think pm_qos is the best mechanism for that, maybe something
new needs to be devised.

Regards,

Tomeu

>
> Comments are welcomed. Maybe on other platforms this has bigger impact?
>
> Best regards,
> Krzysztof
>
>
> Krzysztof Kozlowski (3):
>   mmc: Add dynamic frequency scaling
>   ARM: dts: Specify MSHC realistic clocks and use frequency scaling
>   ARM: dts: Use frequency scaling for MSHC
>
>  Documentation/devicetree/bindings/mmc/mmc.txt |   2 +
>  arch/arm/boot/dts/exynos3250-rinato.dts       |   1 +
>  arch/arm/boot/dts/exynos4412-trats2.dts       |   4 +-
>  drivers/mmc/card/block.c                      | 247 ++++++++++++++++++++++++++
>  drivers/mmc/core/Kconfig                      |  16 ++
>  drivers/mmc/core/core.h                       |   1 -
>  drivers/mmc/core/host.c                       |   2 +
>  include/linux/mmc/card.h                      |   8 +
>  include/linux/mmc/host.h                      |   3 +
>  9 files changed, 282 insertions(+), 2 deletions(-)
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
