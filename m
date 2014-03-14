Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaCNMRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:17:33 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33018 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbaCNMRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:17:30 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-23-5322f358de41
Message-id: <5322F356.6030608@samsung.com>
Date: Fri, 14 Mar 2014 13:17:26 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 11/27] clk: exynos: add gate clock descriptions of
 System MMU
References: <20140314140621.14df1e40601c4f6a2487b5a8@samsung.com>
In-reply-to: <20140314140621.14df1e40601c4f6a2487b5a8@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Fd2Iz0rBBpdf8VjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S3+9R5ktJiy6DCrxeE3
	7awWJ//0MlrMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MrY/2A5c0E/b8XEv10sDYybuLoYOTkkBEwk/h84xghh
	i0lcuLeerYuRi0NIYCmjxMFppxghnM+MEte6H7KCVPEKaEl83fWTDcRmEVCVmDNtNVicTUBN
	4nPDI7A4P1DNmqbrLCC2qECExNyJm9kgegUlfky+xwIyVERgHZPEsSM7wRxmgd9MEs/ePWbu
	YmTnEBYIl7jKDFIvJOAose7PFLA5nAJOEn+etLOD2MwC1hIrJ21jhLDlJTavecs8gVFwFpIV
	s5CUzUJStoCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSMx92cG4+JjVIUYBDkYlHt6T
	7xWDhVgTy4orcw8xSnAwK4nwnnysFCzEm5JYWZValB9fVJqTWnyIkYmDU6qBceOpro/fgrLL
	mX8zTpD/sylAK3y1lEb3bcVpz1w1Em0+l/DJL6xt/Njylv2A6d/9+9p/HYxTjjY1WbRa5Wnc
	6XtyNbUnt+vkly9Tcha8IvTP2LS2vYt5l96C5YtVXrGVLfp5fImIcvjHRwobMr4xdT+9rifk
	X5Fs9+8xy8b69d6W/4TW9W+epcRSnJFoqMVcVJwIAAvzU4GXAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On 14.03.2014 06:06, Cho KyongHo wrote:
> This adds gate clocks of all System MMUs and their master IPs
> that are not apeared in clk-exynos5250.c and clk-exynos5420.c
> Also fixes GATE_IP_ACP to 0x18800 and changed GATE_DA to GATE
> for System MMU clocks in clk-exynos4.c
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>   .../devicetree/bindings/clock/exynos5250-clock.txt |    3 +++
>   .../devicetree/bindings/clock/exynos5420-clock.txt |    6 +++++-
>   drivers/clk/samsung/clk-exynos5250.c               |    5 +++++
>   drivers/clk/samsung/clk-exynos5420.c               |   13 +++++++++++--
>   include/dt-bindings/clock/exynos5250.h             |    4 ++++
>   include/dt-bindings/clock/exynos5420.h             |    6 +++++-
>   6 files changed, 33 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> index 72ce617..67e50ba 100644
> --- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> @@ -162,6 +162,9 @@ clock which they consume.
>     g2d			345
>     mdma0			346
>     smmu_mdma0		347
> +  smmu_tv		348
> +  smmu_fimd1		349
> +  smmu_2d		350
>

This patch should be rebased on top of Andrzej Hajda's patches removing 
these clock ID listings and reworking dts files to use defined macros. 
They are present in v3.15-next/dt-clk-exynos branch of linux-samsung 
tree, but I have asked Kukjin to merge them to his for-next branch, so 
they could show up in linux-next tree.

Best regards,
Tomasz
