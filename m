Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbbAGOjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:39:24 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37573 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbbAGOjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:39:22 -0500
Message-ID: <54AD4516.7050608@gmail.com>
Date: Wed, 07 Jan 2015 15:39:18 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Jisheng Zhang <jszhang@marvell.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, antoine.tenart@free-electrons.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: dts: berlin: add PPI cpu mask to twd timer
 interrupts
References: <1419584281-4811-1-git-send-email-jszhang@marvell.com> <1419584281-4811-3-git-send-email-jszhang@marvell.com>
In-Reply-To: <1419584281-4811-3-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.12.2014 09:58, Jisheng Zhang wrote:
> According to the gic binding document, "bits[15:8] PPI interrupt cpu
> mask.  Each bit corresponds to each of the 8 possible cpus attached to
> the GIC.  A bit set to '1' indicated the interrupt is wired to that
> CPU." This patch wants to add the PPI cpu mask for completeness.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Applied to berlin/dt.

Thanks!

> ---
>   arch/arm/boot/dts/berlin2.dtsi   | 2 +-
>   arch/arm/boot/dts/berlin2cd.dtsi | 2 +-
>   arch/arm/boot/dts/berlin2q.dtsi  | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> index 015a06c..63d00a6 100644
> --- a/arch/arm/boot/dts/berlin2.dtsi
> +++ b/arch/arm/boot/dts/berlin2.dtsi
> @@ -104,7 +104,7 @@
>   		local-timer@ad0600 {
>   			compatible = "arm,cortex-a9-twd-timer";
>   			reg = <0xad0600 0x20>;
> -			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_HIGH)>;
>   			clocks = <&chip CLKID_TWD>;
>   		};
>
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index a318bc3..81b670a 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -76,7 +76,7 @@
>   		local-timer@ad0600 {
>   			compatible = "arm,cortex-a9-twd-timer";
>   			reg = <0xad0600 0x20>;
> -			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_HIGH)>;
>   			clocks = <&chip CLKID_TWD>;
>   		};
>
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 933dcbb..41a683f 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -112,7 +112,7 @@
>   			compatible = "arm,cortex-a9-twd-timer";
>   			reg = <0xad0600 0x20>;
>   			clocks = <&chip CLKID_TWD>;
> -			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
>   		};
>
>   		gic: interrupt-controller@ad1000 {
>

