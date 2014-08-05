Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaHENgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:36:09 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:60660 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaHENgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:36:04 -0400
Date: Tue, 5 Aug 2014 09:34:55 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: rui.zhang@intel.com, swarren@wwwdotorg.org, thierry.reding@gmail.com,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] of: Add bindings for nvidia,tegra124-soctherm
Message-ID: <20140805133455.GA20354@developer>
References: <1407241137-32232-1-git-send-email-mperttunen@nvidia.com>
 <1407241137-32232-2-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407241137-32232-2-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko,

On Tue, Aug 05, 2014 at 03:18:54PM +0300, Mikko Perttunen wrote:
> This adds binding documentation and headers for the Tegra124
> SOCTHERM device tree node.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>  .../devicetree/bindings/thermal/tegra-soctherm.txt | 35 ++++++++++++++++++++++
>  include/dt-bindings/thermal/tegra124-soctherm.h    | 13 ++++++++
>  2 files changed, 48 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/tegra-soctherm.txt
>  create mode 100644 include/dt-bindings/thermal/tegra124-soctherm.h
> 
> diff --git a/Documentation/devicetree/bindings/thermal/tegra-soctherm.txt b/Documentation/devicetree/bindings/thermal/tegra-soctherm.txt
> new file mode 100644
> index 0000000..3505c8f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/tegra-soctherm.txt
> @@ -0,0 +1,35 @@
> +Tegra124 SOCTHERM thermal management system
> +

It would be kind of you to add a more descriptive information of this
device here.

> +Required properties :
> +- compatible : "nvidia,tegra124-soctherm".
> +- reg : Should contain 1 entry:
> +  - SOCTHERM register set
> +- interrupts : Defines the interrupt used by SOCTHERM
> +- clocks : Must contain an entry for each entry in clock-names.
> +  See ../clocks/clock-bindings.txt for details.
> +- clock-names : Must include the following entries:
> +  - tsensor
> +  - soctherm
> +- resets : Must contain an entry for each entry in reset-names.
> +  See ../reset/reset.txt for details.
> +- reset-names : Must include the following entries:
> +  - soctherm
> +- #thermal-sensor-cells : Should be 1. See ./thermal.txt for a description
> +    of this property. See <dt-bindings/thermal/tegra124-soctherm.h> for a
> +    list of valid values.
> +
> +
> +Example :
> +
> +	soctherm@0,700e2000 {
> +		compatible = "nvidia,tegra124-soctherm";
> +		reg = <0x0 0x700e2000 0x0 0x1000>;
> +		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&tegra_car TEGRA124_CLK_TSENSOR>,
> +			<&tegra_car TEGRA124_CLK_SOC_THERM>;
> +		clock-names = "tsensor", "soctherm";
> +		resets = <&tegra_car 78>;
> +		reset-names = "soctherm";
> +
> +		#thermal-sensor-cells = <1>;
> +	};
> diff --git a/include/dt-bindings/thermal/tegra124-soctherm.h b/include/dt-bindings/thermal/tegra124-soctherm.h
> new file mode 100644
> index 0000000..85aaf66
> --- /dev/null
> +++ b/include/dt-bindings/thermal/tegra124-soctherm.h
> @@ -0,0 +1,13 @@
> +/*
> + * This header provides constants for binding nvidia,tegra124-soctherm.
> + */
> +
> +#ifndef _DT_BINDINGS_THERMAL_TEGRA124_SOCTHERM_H
> +#define _DT_BINDINGS_THERMAL_TEGRA124_SOCTHERM_H
> +
> +#define TEGRA124_SOCTHERM_SENSOR_CPU 0
> +#define TEGRA124_SOCTHERM_SENSOR_MEM 1
> +#define TEGRA124_SOCTHERM_SENSOR_GPU 2
> +#define TEGRA124_SOCTHERM_SENSOR_PLLX 3
> +

Having examples of usages of above defines improves the understanding of
why we need them. Now, the way this patch is put, looks like they are
optional (not even needed). For instance, you mention in the
thermal-sensor-cells "Should be 1", so, why having extra defines? 

> +#endif
> -- 
> 1.8.1.5
> 

