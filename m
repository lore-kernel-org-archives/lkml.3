Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3LTVBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:01:50 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34666 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3LTVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:01:47 -0500
Message-ID: <52B4B035.4090102@samsung.com>
Date: Sat, 21 Dec 2013 06:01:41 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com, t.figa@samsung.com
Subject: Re: [PATCH v12 4/4] ARM: dts: Exynos5420: Add device nodes for TMU
 blocks
References: <1382004240-3282-1-git-send-email-l.krishna@samsung.com> <1387516281-10273-1-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1387516281-10273-1-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 14:11, Naveen Krishna Chatradhi wrote:
> Exynos5420 SoC has per core thermal management unit.
> 5 TMU channels 4 for CPUs and 5th for GPU.
>
> This patch adds the device tree nodes to the DT device list.
>
> Nodes carry the misplaced second base address and the second
> clock to access the misplaced base address.
>
> Signed-off-by: Leela Krishna Amudala<l.krishna@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
> Signed-off-by: Andrew Bresticker<abrestic@chromium.org>
> ---
> Changes since v11:
>    changed the secondary clock name to "tmu_triminfo_apbif"
> from "tmu_apbif_triminfo"
>
> Changes since previous version:
> 1. used lables instead of comment lines
> 2. pass the same clock as trimfo_apbif clock for TMU channel 2
> 3. Fixed a coding style problem pointed by Tomasz
>
>   arch/arm/boot/dts/exynos5420.dtsi |   40 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index b1fa334..c62cde6 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -402,4 +402,44 @@
>   		clock-names = "gscl";
>   		samsung,power-domain =<&gsc_pd>;
>   	};
> +
> +	tmu_cpu0: tmu@10060000 {
> +		compatible = "samsung,exynos5420-tmu";
> +		reg =<0x10060000 0x100>;
> +		interrupts =<0 65 0>;
> +		clocks =<&clock 318>;
> +		clock-names = "tmu_apbif";
> +	};
> +
> +	tmu_cpu1: tmu@10064000 {
> +		compatible = "samsung,exynos5420-tmu";
> +		reg =<0x10064000 0x100>;
> +		interrupts =<0 183 0>;
> +		clocks =<&clock 318>;
> +		clock-names = "tmu_apbif";
> +	};
> +
> +	tmu_cpu2: tmu@10068000 {
> +		compatible = "samsung,exynos5420-tmu-ext-triminfo";
> +		reg =<0x10068000 0x100>,<0x1006c000 0x4>;
> +		interrupts =<0 184 0>;
> +		clocks =<&clock 318>,<&clock 318>;
> +		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
> +	};
> +
> +	tmu_cpu3: tmu@1006c000 {
> +		compatible = "samsung,exynos5420-tmu-ext-triminfo";
> +		reg =<0x1006c000 0x100>,<0x100a0000 0x4>;
> +		interrupts =<0 185 0>;
> +		clocks =<&clock 318>,<&clock 319>;
> +		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
> +	};
> +
> +	tmu_gpu: tmu@100a0000 {
> +		compatible = "samsung,exynos5420-tmu-ext-triminfo";
> +		reg =<0x100a0000 0x100>,<0x10068000 0x4>;
> +		interrupts =<0 215 0>;
> +		clocks =<&clock 319>,<&clock 318>;
> +		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
> +	};
>   };

Looks good to me, applied.
Merry Christmas :-)

- Kukjin
