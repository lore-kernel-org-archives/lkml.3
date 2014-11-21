Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbaKUM6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:58:07 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36666 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbaKUM6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:58:05 -0500
Message-ID: <546F36D3.4090008@arm.com>
Date: Fri, 21 Nov 2014 12:57:55 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
CC: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: Re: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414503414-3863-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1414503414-3863-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

On 28/10/14 13:36, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Initial revision of device tree for AMD Seattle platform
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
> ---
> Change in V3:
> 	* Change sata compatible-id to "snps,dwc-ahci"
> 
>  arch/arm64/Kconfig                          |   5 +
>  arch/arm64/boot/dts/Makefile                |   1 +
>  arch/arm64/boot/dts/amd-seattle-periph.dtsi | 164 ++++++++++++++++++++++++++++
>  arch/arm64/boot/dts/amd-seattle.dts         | 122 +++++++++++++++++++++
>  4 files changed, 292 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/amd-seattle-periph.dtsi
>  create mode 100644 arch/arm64/boot/dts/amd-seattle.dts
> 

[...]

> diff --git a/arch/arm64/boot/dts/amd-seattle.dts b/arch/arm64/boot/dts/amd-seattle.dts
> new file mode 100644
> index 0000000..726e444
> --- /dev/null
> +++ b/arch/arm64/boot/dts/amd-seattle.dts
> @@ -0,0 +1,122 @@
> +/*
> + * DTS file for AMD Seattle
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + */
> +
> +/dts-v1/;
> +
> +/ {
> +	compatible = "amd,seattle";
> +	interrupt-parent = <&gic>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	chosen {
> +		stdout-path = &serial0;
> +		linux,pci-probe-only;
> +	};
> +
> +	gic: interrupt-controller@e1101000 {
> +		compatible = "arm,gic-400", "arm,cortex-a15-gic";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		reg = <0x0 0xe1110000 0 0x1000>,
> +		      <0x0 0xe112f000 0 0x2000>,
> +		      <0x0 0xe1140000 0 0x10000>,
> +		      <0x0 0xe1160000 0 0x10000>;
> +		interrupts = <1 8 0xf04>;

Are you sure about this one? ARM systems usually have this wired on PPI9
(interrupt 25)...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
