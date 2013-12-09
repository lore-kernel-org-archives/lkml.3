Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577Ab3LIM51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:57:27 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18108 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab3LIM5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:57:22 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-ed-52a5be300f48
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH 4/4 v3] ARM: dts: Exynos5420: Add device nodes for TMU
 blocks
Date: Mon, 09 Dec 2013 13:57:09 +0100
Message-id: <3503788.1T16Njt87z@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1384238268-24671-1-git-send-email-ch.naveen@samsung.com>
References: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
 <1384238268-24671-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xy7oG+5YGGZxeJGfRcDXEYuOM9awW
	d58fZrR4eUjTYv6Rc6wWa/b/ZLLoXXCVzeLyrjlsFp97jzBazDi/j8li0bb/zBZPHvaxOfB4
	7Jx1l91j8Z6XTB59W1Yxehy/sZ3J4/MmuQDWKC6blNSczLLUIn27BK6MBy2r2AumClVMvV7T
	wLiar4uRk0NCwETief80ZghbTOLCvfVsXYxcHEICSxklJpydxAjhdDFJdC/czw5SxSagJvG5
	4REbiC0C1H381Rl2kCJmgaVMEvOXLQIbJSwQLHH/+hIwm0VAVaLz7lkWEJtXQFPi0IPvYHF+
	AXWJd9ueMoHYogJuEi/2bQFbwAlk/5qyjAVicwOjxKv1s1khmgUlfky+BzaIWUBeYt/+qawQ
	tpbE+p3HmSYwCs5CUjYLSdksJGULGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoTEy9cd
	jEuPWR1iFOBgVOLhDWBeGiTEmlhWXJl7iFGCg1lJhFdsF1CINyWxsiq1KD++qDQntfgQIxMH
	p1QDo4C0TR93w4kP04wufj7qEVHKOb9gyoV1wT/U/mqFn5SWLXp1oj9Z9e7EwNlc9ko/OBa9
	42zV3qTSuq17vmXepG2sN27oTJw799qk1j6Zu9vvXjg9PV5nhW/K8wdm+20y+50dY1WynvgZ
	pBoddpMWkTawuTB586OjR7YkvmxlOy06aceiVxVT1yixFGckGmoxFxUnAgAMjM15dQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Tuesday 12 of November 2013 12:07:48 Naveen Krishna Chatradhi wrote:
> Exynos5420 SoC has per core thermal management unit.
> 5 TMU channels 4 for CPUs and 5th for GPU.
> 
> This patch adds the device tree nodes to the DT device list.
> 
> Nodes carry the misplaced second base address and the second
> clock to access the misplaced base address.
> 
> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
> Changes since v2:
> 3. uses the new compatible strings introduced along with adding
>    support for Exynso5420.
> 
> Changes since v1:
> 1. Nodes carry the misplaced second base address and the second
>    clock to access the misplaced base address.
> 2. Correct the clock number for the TMU4
> 
>  arch/arm/boot/dts/exynos5420.dtsi |   48 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)

In addition to updating to reflect my comments to patch 3/4, please also
see my comments inline.

> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 6ffefd1..d736b40 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -369,4 +369,52 @@
>  		clock-names = "gscl";
>  		samsung,power-domain = <&gsc_pd>;
>  	};
> +
> +	/* tmu for CPU0 */
> +	tmu@10060000 {

Instead of the comment, it might be better to add a label to the node,
such as

tmu_cpu0: tmu@10060000 {

for TMU of CPU0 and so on.

> +		compatible = "samsung,exynos5420-tmu";
> +		reg = <0x10060000 0x100>;
> +		interrupts = <0 65 0>;
> +		clocks = <&clock 318>;
> +		clock-names = "tmu_apbif";
> +	};
> +
> +	/* tmu for CPU1 */
> +	tmu@10064000 {
> +		compatible = "samsung,exynos5420-tmu";
> +		reg = <0x10064000 0x100>;
> +		interrupts = <0 183 0>;
> +		clocks = <&clock 318>;
> +		clock-names = "tmu_apbif";
> +	};
> +
> +	/* tmu for CPU2 */
> +	tmu@10068000 {
> +		compatible = "samsung,exynos5420-tmu-triminfo";
> +		/* 2nd reg is for the misplaced TRIMINFO register */

Hmm, I'm not convinced about usefulness of this comment. Used compatible
value directly implies the meaning of all reg entries.

Best regards,
Tomasz

