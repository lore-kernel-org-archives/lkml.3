Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567Ab3LIVco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:32:44 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:43317 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864Ab3LIVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:32:40 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        naveenkrishna.ch@gmail.com
Cc: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com, t.figa@samsung.com
Subject: Re: [PATCH 4/4 v4] ARM: dts: Exynos5420: Add device nodes for TMU blocks
Date: Mon, 09 Dec 2013 22:32:33 +0100
Message-ID: <4444992.uYV4fhSHQI@flatron>
User-Agent: KMail/4.11.4 (Linux/3.12.2-gentoo; KDE/4.11.4; x86_64; ; )
In-Reply-To: <52A632DC.6040509@samsung.com>
References: <1382004240-3282-1-git-send-email-l.krishna@samsung.com> <1384866359-16157-1-git-send-email-ch.naveen@samsung.com> <52A632DC.6040509@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On Tuesday 10 of December 2013 06:15:08 Kukjin Kim wrote:
> On 11/19/13 22:05, Naveen Krishna Chatradhi wrote:
> > Exynos5420 SoC has per core thermal management unit.
> > 5 TMU channels 4 for CPUs and 5th for GPU.
> >
> > This patch adds the device tree nodes to the DT device list.
> >
> > Nodes carry the misplaced second base address and the second
> > clock to access the misplaced base address.
> >
> > Signed-off-by: Leela Krishna Amudala<l.krishna@samsung.com>
> > Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
> > Signed-off-by: Andrew Bresticker<abrestic@chromium.org>
> > ---
> > Changes since v3:
> > None, Just respinning
> >
> > Changes since v2:
> > 3. uses the new compatible strings introduced along with adding
> >     support for Exynso5420.
> >
> > Changes since v1:
> > 1. Nodes carry the misplaced second base address and the second
> >     clock to access the misplaced base address.
> > 2. Correct the clock number for the TMU4
> >
> >   arch/arm/boot/dts/exynos5420.dtsi |   48 +++++++++++++++++++++++++++++++++++++
> >   1 file changed, 48 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> > index 6ffefd1..d736b40 100644
> > --- a/arch/arm/boot/dts/exynos5420.dtsi
> > +++ b/arch/arm/boot/dts/exynos5420.dtsi
> > @@ -369,4 +369,52 @@
> >   		clock-names = "gscl";
> >   		samsung,power-domain =<&gsc_pd>;
> >   	};
> > +
> > +	/* tmu for CPU0 */
> > +	tmu@10060000 {
> > +		compatible = "samsung,exynos5420-tmu";
> > +		reg =<0x10060000 0x100>;
> > +		interrupts =<0 65 0>;
> > +		clocks =<&clock 318>;
> > +		clock-names = "tmu_apbif";
> > +	};
> > +
> > +	/* tmu for CPU1 */
> > +	tmu@10064000 {
> > +		compatible = "samsung,exynos5420-tmu";
> > +		reg =<0x10064000 0x100>;
> > +		interrupts =<0 183 0>;
> > +		clocks =<&clock 318>;
> > +		clock-names = "tmu_apbif";
> > +	};
> > +
> > +	/* tmu for CPU2 */
> > +	tmu@10068000 {
> > +		compatible = "samsung,exynos5420-tmu-triminfo";
> > +		/* 2nd reg is for the misplaced TRIMINFO register */
> > +		reg =<0x10068000 0x100>,<0x1006c000 0x4>;
> > +		interrupts =<0 184 0>;
> > +		clocks =<&clock 318>;
> > +		clock-names = "tmu_apbif";
> > +	};
> > +
> > +	/* tmu for CPU3 */
> > +	tmu@1006c000 {
> > +		compatible = "samsung,exynos5420-tmu-triminfo-clk";
> > +		/* 2nd reg is for the misplaced TRIMINFO register */
> > +		reg =<0x1006c000 0x100>,<0x100a0000 0x4>;
> > +		interrupts =<0 185 0>;
> > +		clocks =<&clock 318>,<&clock 319>;
> > +		clock-names = "tmu_apbif", "tmu_apbif_triminfo";
> > +	};
> > +
> > +	/* tmu for GPU */
> > +	tmu@100a0000 {
> > +		compatible = "samsung,exynos5420-tmu-triminfo-clk";
> > +		/* 2nd reg is for the misplaced TRIMINFO register */
> > +		reg =<0x100a0000 0x100>,<0x10068000 0x4>;
> > +		interrupts =<0 215 0>;
> > +		clocks =<&clock 319>,<&clock 318>;
> > +		clock-names = "tmu_apbif", "tmu_apbif_triminfo";
> > +	};
> >   };
> 
> BTW, there is just only this patch to support TMU on exynos5420?

This patch is a part of a 4-patch series, but unfortunately it was not
sent with correct threading, so it's hard to find remaing patches,
which are:

[PATCH 1/4 v9] thermal: samsung: replace inten_ bit fields with intclr_
[PATCH 2/4 v10] thermal: samsung: change base_common to more meaningful base_second
[PATCH 3/4 v10] thermal: samsung: Add TMU support for Exynos5420 SoCs

There are comments to be addressed to those patches, so I guest at least
one more iteration is needed.

Naveen, it would be nice if you could send next version with proper
threading and consistent versioning. Thanks in advance.

Best regards,
Tomasz

