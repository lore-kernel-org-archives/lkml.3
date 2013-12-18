Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3LRICg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 03:02:36 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55765 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3LRICe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 03:02:34 -0500
Message-ID: <52B1568F.1050305@gmail.com>
Date: Wed, 18 Dec 2013 16:02:23 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        swarren@nvidia.com, will.deacon@arm.com, grant.likely@linaro.org,
        thierry.reding@gmail.com, robherring2@gmail.com, joro@8bytes.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, galak@codeaurora.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 06/12] ARM: tegra: create a DT header defining SWGROUP
 ID
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-7-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1386835033-4701-7-git-send-email-hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 03:57 PM, Hiroshi Doyu wrote:
> Create a header file to define the swgroup IDs used by the IOMMU(SMMU)
> binding. "swgroup" is a group of H/W clients which a Tegra SoC
> supports. This unique ID can be used to calculate MC_SMMU_<swgroup
> name>_ASID_0 register offset and MC_<swgroup name>_HOTRESET_*_0
> register bit. This will allow the same header to be used by both
> device tree files, and drivers implementing this binding, which
> guarantees that the two stay in sync. This also makes device trees
> more readable by using names instead of magic numbers. For HOTRESET
> bit shifting we need another conversion table, which will come later.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
> v6:
> Use 0xffffffff instead of ~0UL since dtc expand this to ~0ULL.
> 
> v5:
> Added new macro TEGRA_SWGROUP_CELLS() and WO_U32_OF_U64().
> 
> v4:
> This is almost same as the previous v3. Just TEGRA_SWGROUP_MAX is
> added.
>   [PATCHv3 15/19] ARM: tegra: Create a DT header defining SWGROUP ID
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
>  include/dt-bindings/memory/tegra-swgroup.h | 50 ++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 include/dt-bindings/memory/tegra-swgroup.h
> 
> diff --git a/include/dt-bindings/memory/tegra-swgroup.h b/include/dt-bindings/memory/tegra-swgroup.h
> new file mode 100644
> index 0000000..9c279f1
> --- /dev/null
> +++ b/include/dt-bindings/memory/tegra-swgroup.h
> @@ -0,0 +1,50 @@
> +/*
> + * This header provides constants for binding nvidia,swgroup ID
> + */
> +
> +#ifndef _DT_BINDINGS_MEMORY_TEGRA_SWGROUP_H
> +#define _DT_BINDINGS_MEMORY_TEGRA_SWGROUP_H
> +
> +#define TEGRA_SWGROUP_AFI	0	/* 0x238 */
> +#define TEGRA_SWGROUP_AVPC	1	/* 0x23c */
> +#define TEGRA_SWGROUP_DC	2	/* 0x240 */
> +#define TEGRA_SWGROUP_DCB	3	/* 0x244 */
> +#define TEGRA_SWGROUP_EPP	4	/* 0x248 */
> +#define TEGRA_SWGROUP_G2	5	/* 0x24c */
> +#define TEGRA_SWGROUP_HC	6	/* 0x250 */
> +#define TEGRA_SWGROUP_HDA	7	/* 0x254 */
> +#define TEGRA_SWGROUP_ISP	8	/* 0x258 */
> +#define TEGRA_SWGROUP_ISP2	SWGROUP_ISP
> +#define TEGRA_SWGROUP_DC14	9	/* 0x490 *//* Exceptional non-linear */
> +#define TEGRA_SWGROUP_DC12	10	/* 0xa88 *//* Exceptional non-linear */
> +#define TEGRA_SWGROUP_MPE	11	/* 0x264 */
> +#define TEGRA_SWGROUP_MSENC	SWGROUP_MPE

Need to change this to:

#define TEGRA_SWGROUP_MSENC	11

The reason is that, this makes "TEGRA_SWGROUP_BIT" doesn't work. So if I
write "TEGRA_SWGROUP_CELLS(MSENC)" in dt, that causes a dt compiling error.

"TEGRA_SWGROUP_ISP2" has the same issue.

Mark
> +#define TEGRA_SWGROUP_NV	12	/* 0x268 */
> +#define TEGRA_SWGROUP_NV2	13	/* 0x26c */
> +#define TEGRA_SWGROUP_PPCS	14	/* 0x270 */
> +#define TEGRA_SWGROUP_SATA2	15	/* 0x274 */
> +#define TEGRA_SWGROUP_SATA	16	/* 0x278 */
> +#define TEGRA_SWGROUP_VDE	17	/* 0x27c */
> +#define TEGRA_SWGROUP_VI	18	/* 0x280 */
> +#define TEGRA_SWGROUP_VIC	19	/* 0x284 */
> +#define TEGRA_SWGROUP_XUSB_HOST	20	/* 0x288 */
> +#define TEGRA_SWGROUP_XUSB_DEV	21	/* 0x28c */
> +#define TEGRA_SWGROUP_A9AVP	22	/* 0x290 */
> +#define TEGRA_SWGROUP_TSEC	23	/* 0x294 */
> +#define TEGRA_SWGROUP_PPCS1	24	/* 0x298 */
> +#define TEGRA_SWGROUP_SDMMC1A	25	/* 0xa94 *//* Linear shift again */
> +#define TEGRA_SWGROUP_SDMMC2A	26	/* 0xa98 */
> +#define TEGRA_SWGROUP_SDMMC3A	27	/* 0xa9c */
> +#define TEGRA_SWGROUP_SDMMC4A	28	/* 0xaa0 */
> +#define TEGRA_SWGROUP_ISP2B	29	/* 0xaa4 */
> +#define TEGRA_SWGROUP_GPU	30	/* 0xaa8 */
> +#define TEGRA_SWGROUP_GPUB	31	/* 0xaac */
> +#define TEGRA_SWGROUP_PPCS2	32	/* 0xab0 */
> +
> +#define TWO_U32_OF_U64(x)	((x) & 0xffffffff) ((x) >> 32)
> +#define TEGRA_SWGROUP_BIT(x)	(1ULL << TEGRA_SWGROUP_##x)
> +#define TEGRA_SWGROUP_CELLS(x)	TWO_U32_OF_U64(TEGRA_SWGROUP_BIT(x))
> +
> +#define TEGRA_SWGROUP_MAX	64
> +
> +#endif /* _DT_BINDINGS_MEMORY_TEGRA_SWGROUP_H */
> 
