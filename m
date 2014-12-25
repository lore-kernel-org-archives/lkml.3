Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaLYNSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 08:18:13 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65105 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaLYNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 08:18:07 -0500
Message-ID: <549C0E8A.6010709@gmail.com>
Date: Thu, 25 Dec 2014 14:18:02 +0100
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
Subject: Re: [PATCH 2/2] ARM: dts: berlin: add PPI cpu mask to twd timer interrupts
References: <1419487942-2277-1-git-send-email-jszhang@marvell.com> <1419487942-2277-3-git-send-email-jszhang@marvell.com>
In-Reply-To: <1419487942-2277-3-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.12.2014 07:12, Jisheng Zhang wrote:
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Jisheng,

thanks for the patches!

Please always add some text to the commit log, no matter how simple the
change is.

> ---
>   arch/arm/boot/dts/berlin2.dtsi   | 3 ++-
>   arch/arm/boot/dts/berlin2cd.dtsi | 3 ++-
>   arch/arm/boot/dts/berlin2q.dtsi  | 3 ++-
>   3 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> index 015a06c..f6d9002 100644
> --- a/arch/arm/boot/dts/berlin2.dtsi
> +++ b/arch/arm/boot/dts/berlin2.dtsi
> @@ -104,7 +104,8 @@
>   		local-timer@ad0600 {
>   			compatible = "arm,cortex-a9-twd-timer";
>   			reg = <0xad0600 0x20>;
> -			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(2) |
> +					IRQ_TYPE_LEVEL_HIGH)>;

IMHO, feel free to ignore 80-column restriction on each of the lines
changed.

Sebastian

>   			clocks = <&chip CLKID_TWD>;
>   		};
>
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index a318bc3..517a364 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -76,7 +76,8 @@
>   		local-timer@ad0600 {
>   			compatible = "arm,cortex-a9-twd-timer";
>   			reg = <0xad0600 0x20>;
> -			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(1) |
> +					IRQ_TYPE_LEVEL_HIGH)>;
>   			clocks = <&chip CLKID_TWD>;
>   		};
>
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 933dcbb..33fbf8f 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -112,7 +112,8 @@
>   			compatible = "arm,cortex-a9-twd-timer";
>   			reg = <0xad0600 0x20>;
>   			clocks = <&chip CLKID_TWD>;
> -			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) |
> +					IRQ_TYPE_LEVEL_HIGH)>;
>   		};
>
>   		gic: interrupt-controller@ad1000 {
>

