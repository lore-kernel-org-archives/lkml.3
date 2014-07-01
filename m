Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbaGAMPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:15:10 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7759 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaGAMPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:15:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 01 Jul 2014 05:08:35 -0700
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, "Joerg Roedel" <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        "Grant Grundler" <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>,
        "Marc Zyngier" <marc.zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <AMartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
In-Reply-To: <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
Date: Tue, 1 Jul 2014 15:14:52 +0300
Message-ID: <8761jh9sxv.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thierry Reding <thierry.reding@gmail.com> writes:

> diff --git a/include/dt-bindings/memory/tegra124-mc.h b/include/dt-bindings/memory/tegra124-mc.h
> new file mode 100644
> index 000000000000..6b1617ce022f
> --- /dev/null
> +++ b/include/dt-bindings/memory/tegra124-mc.h
> @@ -0,0 +1,30 @@
> +#ifndef DT_BINDINGS_MEMORY_TEGRA124_MC_H
> +#define DT_BINDINGS_MEMORY_TEGRA124_MC_H
> +
> +#define TEGRA_SWGROUP_DC       0
> +#define TEGRA_SWGROUP_DCB      1
> +#define TEGRA_SWGROUP_AFI      2
> +#define TEGRA_SWGROUP_AVPC     3
> +#define TEGRA_SWGROUP_HDA      4
> +#define TEGRA_SWGROUP_HC       5
> +#define TEGRA_SWGROUP_MSENC    6
> +#define TEGRA_SWGROUP_PPCS     7
> +#define TEGRA_SWGROUP_SATA     8
> +#define TEGRA_SWGROUP_VDE      9
> +#define TEGRA_SWGROUP_MPCORELP 10
> +#define TEGRA_SWGROUP_MPCORE   11
> +#define TEGRA_SWGROUP_ISP2     12
> +#define TEGRA_SWGROUP_XUSB_HOST        13
> +#define TEGRA_SWGROUP_XUSB_DEV 14
> +#define TEGRA_SWGROUP_ISP2B    15
> +#define TEGRA_SWGROUP_TSEC     16
> +#define TEGRA_SWGROUP_A9AVP    17
> +#define TEGRA_SWGROUP_GPU      18
> +#define TEGRA_SWGROUP_SDMMC1A  19
> +#define TEGRA_SWGROUP_SDMMC2A  20
> +#define TEGRA_SWGROUP_SDMMC3A  21
> +#define TEGRA_SWGROUP_SDMMC4A  22
> +#define TEGRA_SWGROUP_VIC      23
> +#define TEGRA_SWGROUP_VI       24
> +
> +#endif

In the SMMUv8 patch series, I have assigned unique IDs for all those
HWAs among Tegra SoC generations so that DT can provide which HWAs are
attached to that SoC. The SMMUv8 driver would be unified among Tegra
SoCs, then.
