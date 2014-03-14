Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaCNNnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:43:49 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35428 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaCNNnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:43:47 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-c1-532307903c01
Message-id: <5323078E.4060903@samsung.com>
Date: Fri, 14 Mar 2014 14:43:42 +0100
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
Subject: Re: [PATCH v11 15/27] iommu/exynos: use convenient macro to handle
 gate clocks
References: <20140314140951.3d443a3096e80297c9fecef0@samsung.com>
In-reply-to: <20140314140951.3d443a3096e80297c9fecef0@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4Fd0J7MrBBgtfq1ncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S3+9R5ktJiy6DCrxeE3
	7awWJ//0MlrMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mr4PW0NU8FFrorlp++xNzA+4ehi5OSQEDCR+LnqIROE
	LSZx4d56ti5GLg4hgaWMEp/3L2eFcD4zSqx+/4sFpIpXQEvi9+KXzCA2i4CqxM49x8BsNgE1
	ic8Nj9hAbH6gmjVN18HqRQUiJOZO3MwG0Sso8WPyPRaQoSIC65gkjh3ZCeYwC/xmknj27jHY
	JGGBSIm93R1gtpCAo8TpqbPBujkFnCSm373ODmIzC1hLrJy0jRHClpfYvOYt8wRGwVlIlsxC
	UjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFx93UH49JjVocYBTgYlXh4ZxxV
	DBZiTSwrrsw9xCjBwawkwnvysVKwEG9KYmVValF+fFFpTmrxIUYmDk6pBsZdwpeEd74oVowJ
	1tnSzOT+6NGCxqQfG/b0TpkUqa2wyemB3Rx9k1OMGQqTPii1Od75djOLQVcgfrWvyUYlrd6P
	Z/+crnBxf8UWt4TH3VSe60Nq3bZc2etha5hvF72YbPjp5bXiBfv21QZWOaVu+72rQ/s495qK
	C7WnTq6VUJu/nDVCcf/jtVuVWIozEg21mIuKEwHF9WOjmQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On 14.03.2014 06:09, Cho KyongHo wrote:
> exynos-iommu driver must care about master H/W's gate clock as well as
> System MMU's gate clock. To enhance readability of the source code,
> macros to gate/ungate those clocks are defined.
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>   drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++------------
>   1 file changed, 22 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 71e77f1..cef62d0 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -101,6 +101,16 @@
>   #define REG_PB1_SADDR		0x054
>   #define REG_PB1_EADDR		0x058
>
> +#define __clk_gate_ctrl(data, clk, en)	do {		\
> +		if (data->clk)				\
> +			clk_##en##able(data->clk);	\
> +	} while (0)
> +
> +#define __sysmmu_clk_enable(data)	__clk_gate_ctrl(data, clk, en)
> +#define __sysmmu_clk_disable(data)	__clk_gate_ctrl(data, clk, dis)
> +#define __master_clk_enable(data)	__clk_gate_ctrl(data, clk_master, en)
> +#define __master_clk_disable(data)	__clk_gate_ctrl(data, clk_master, dis)
> +

I'd say that such macros only obfuscate code, without any gains, as you 
can see in diffstat - this patch adds more lines than it removes.

Please drop this change.

Best regards,
Tomasz
