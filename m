Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887AbaCSMTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:19:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20689 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbaCSMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:18:59 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-a9-53298b2b84c2
Message-id: <53298B26.8020400@samsung.com>
Date: Wed, 19 Mar 2014 13:18:46 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/4] drivers: clk: use CONFIG_COMMON_CLK_SAMSUNG for
 Samsung clock support
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
 <1394598781-3848-3-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1394598781-3848-3-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xa7ra3ZrBBos/qFhsenyN1eLyrjls
	FjPO72OyWLT1C7sDi8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH7VxtLwSSeimN/
	HrI3MLZxdTFycEgImEh8n1vaxcgJZIpJXLi3ng3EFhJYyijRtVmwi5ELyP7MKNHy4gkjSIJX
	QEvi57dJTCA2i4CqxM32HWANbAJqEp8bHoHZ/EA1a5qus4DYogIREnMnbmaD6BWU+DH5HgvI
	UBGBaYwS12c0soMkhAWSJeZues0Osa2VUeLcvmdg3ZwCHhIrnk9nBrGZBawlVk7axghhy0ts
	XvOWeQKjwCwkg2chKZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJCQ/bqDcekx
	q0OMAhyMSjy8ErEawUKsiWXFlbmHGCU4mJVEeA/VawYL8aYkVlalFuXHF5XmpBYfYmTi4JRq
	YJQ5fzVg3WyJW12Bh7v1TEv3JbibNs3LPbR22epnx2cGlexw2Xetqy42e2nl1AWi2+ae+SmV
	zOJaJ6Ybn5Z+o0JbUtlEyW193In6c+ekNt7x05kQvGdr+dEYwTM3Wo/wa0hcFpV5UFx5xMbl
	eoKT/YaqDu2IKf5dTfvNVp6Wre+V4VXQNQoIVmIpzkg01GIuKk4EAPqcXO83AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 12.03.2014 05:32, Pankaj Dubey wrote:
> This patch includes Samsung clock Kconfig file, and replaces PLAT_SAMSUNG
> with COMMON_CLK_SAMSUNG for Samsung common clock support.
> Any Samsung SoC want to use Samsung common clock infrastructure can simply
> select COMMON_CLK_SAMSUNG.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   drivers/clk/Kconfig  |    2 ++
>   drivers/clk/Makefile |    2 +-
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 7641965..f2b6179 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -112,3 +112,5 @@ source "drivers/clk/qcom/Kconfig"
>   endmenu
>
>   source "drivers/clk/mvebu/Kconfig"
> +
> +source "drivers/clk/samsung/Kconfig"
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index a367a98..f1da6ee 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -38,7 +38,7 @@ obj-$(CONFIG_PLAT_ORION)		+= mvebu/
>   obj-$(CONFIG_ARCH_MXS)			+= mxs/
>   obj-$(CONFIG_COMMON_CLK_QCOM)		+= qcom/
>   obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
> -obj-$(CONFIG_PLAT_SAMSUNG)		+= samsung/
> +obj-$(CONFIG_COMMON_CLK_SAMSUNG)	+= samsung/
>   obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= shmobile/
>   obj-$(CONFIG_ARCH_SIRF)			+= sirf/
>   obj-$(CONFIG_ARCH_SOCFPGA)		+= socfpga/
>

This patch makes samsung/ subdirectory compile depending on 
CONFIG_COMMON_CLK_SAMSUNG, but nothing selects it yet and thus breaking 
bisection.

Best regards,
Tomasz
