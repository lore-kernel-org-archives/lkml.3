Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaIXScI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:32:08 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41006 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaIXScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:32:06 -0400
Date: Wed, 24 Sep 2014 14:32:06 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: rui.zhang@intel.com, swarren@wwwdotorg.org, thierry.reding@gmail.com,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        juha-matti.tilli@iki.fi
Subject: Re: [PATCH v5 3/4] ARM: tegra: Add thermal trip points for Jetson TK1
Message-ID: <20140924183204.GE27076@developer>
References: <1408616242-21009-1-git-send-email-mperttunen@nvidia.com>
 <1408616242-21009-4-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408616242-21009-4-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mikko,

On Thu, Aug 21, 2014 at 01:17:21PM +0300, Mikko Perttunen wrote:
> This adds critical trip points to the Jetson TK1 device tree.
> The device will do a controlled shutdown when either the CPU, GPU
> or MEM thermal zone reaches 101 degrees Celsius.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
> v5: added cooling-maps nodes
> 

OK. But no cooling map entry in it. What was the reason again you don't
need/want to add the maps?

>  arch/arm/boot/dts/tegra124-jetson-tk1.dts | 41 +++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> index 0cdb5cf..bcdab7f 100644
> --- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> +++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> @@ -1876,4 +1876,45 @@
>  			 <&tegra_car TEGRA124_CLK_EXTERN1>;
>  		clock-names = "pll_a", "pll_a_out0", "mclk";
>  	};
> +
> +	thermal-zones {
> +		cpu {
> +			trips {
> +				trip@0 {
> +					temperature = <101000>;
> +					hysteresis = <0>;
> +					type = "critical";
> +				};
> +			};
> +
> +			cooling-maps {
> +			};
> +		};
> +
> +		mem {
> +			trips {
> +				trip@0 {
> +					temperature = <101000>;
> +					hysteresis = <0>;
> +					type = "critical";
> +				};
> +			};
> +
> +			cooling-maps {
> +			};
> +		};
> +
> +		gpu {
> +			trips {
> +				trip@0 {
> +					temperature = <101000>;
> +					hysteresis = <0>;
> +					type = "critical";
> +				};
> +			};
> +
> +			cooling-maps {
> +			};
> +		};
> +	};
>  };
> -- 
> 1.8.1.5
> 
