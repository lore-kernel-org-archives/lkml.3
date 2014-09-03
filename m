Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbaICNjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:39:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44840 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbaICNjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:39:35 -0400
Message-ID: <540719FC.5070803@ti.com>
Date: Wed, 3 Sep 2014 08:39:08 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tony <tony@atomide.com>
CC: <balbi@ti.com>, <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: DRA7: Add PMU nodes
References: <1408456440-30171-1-git-send-email-nm@ti.com>
In-Reply-To: <1408456440-30171-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 08:54 AM, Nishanth Menon wrote:
> From: Lucas Weaver <l-weaver@ti.com>
> 
> DRA74x and DRA72x family of processors vary slightly in the number
> of CPUs. So, add different instances of PMU for each of these processor
> groups. Further, since the interrupts bypass crossbar and are directly
> connected to GIC, mark the dts nodes with relevant information.
> 
> Tested with perf utility.
> 
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Lucas Weaver <l-weaver@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
Hi,
Gentle ping..

Regards,
Nishanth Menon
>  arch/arm/boot/dts/dra72x.dtsi |    5 +++++
>  arch/arm/boot/dts/dra74x.dtsi |    6 ++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dra72x.dtsi b/arch/arm/boot/dts/dra72x.dtsi
> index f1ec22f..e5a3d23 100644
> --- a/arch/arm/boot/dts/dra72x.dtsi
> +++ b/arch/arm/boot/dts/dra72x.dtsi
> @@ -22,4 +22,9 @@
>  			reg = <0>;
>  		};
>  	};
> +
> +	pmu {
> +		compatible = "arm,cortex-a15-pmu";
> +		interrupts = <GIC_SPI DIRECT_IRQ(131) IRQ_TYPE_LEVEL_HIGH>;
> +	};
>  };
> diff --git a/arch/arm/boot/dts/dra74x.dtsi b/arch/arm/boot/dts/dra74x.dtsi
> index a4e8bb9..3be544c 100644
> --- a/arch/arm/boot/dts/dra74x.dtsi
> +++ b/arch/arm/boot/dts/dra74x.dtsi
> @@ -38,4 +38,10 @@
>  			reg = <1>;
>  		};
>  	};
> +
> +	pmu {
> +		compatible = "arm,cortex-a15-pmu";
> +		interrupts = <GIC_SPI DIRECT_IRQ(131) IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI DIRECT_IRQ(132) IRQ_TYPE_LEVEL_HIGH>;
> +	};
>  };
> 


-- 
Regards,
Nishanth Menon
