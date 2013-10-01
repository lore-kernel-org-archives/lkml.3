Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3JAWek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:34:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45231 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab3JAWeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:34:37 -0400
Date: Tue, 1 Oct 2013 17:33:37 -0500
From: Nishanth Menon <nm@ti.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] arm: dts: add dra7 IVA thermal data
Message-ID: <20131001223337.GA11451@kahuna>
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
 <1380652344-18819-3-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1380652344-18819-3-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:32-20131001, Eduardo Valentin wrote:
minor comments follow
> This patch changes a dtsi file to contain the thermal data
s/changes/introduces?
> for IVA domain on DRA7 and later SoCs. This data will
> enable a thermal shutdown at 125C.
> 
> This thermal data can be reused across TI SoC devices.
is'nt it just DRA7 that reuses this - based on dtsi name?
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  arch/arm/boot/dts/dra7-iva-thermal.dtsi | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 arch/arm/boot/dts/dra7-iva-thermal.dtsi
> 
> diff --git a/arch/arm/boot/dts/dra7-iva-thermal.dtsi b/arch/arm/boot/dts/dra7-iva-thermal.dtsi
> new file mode 100644
> index 0000000..fea0cea
> --- /dev/null
> +++ b/arch/arm/boot/dts/dra7-iva-thermal.dtsi
> @@ -0,0 +1,28 @@
> +/*
> + * Device Tree Source for DRA7 SoC IVA thermal
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> + * Contact: Eduardo Valentin <eduardo.valentin@ti.com>
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2.  This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#include <dt-bindings/thermal/thermal.h>
> +
> +iva_thermal: iva_thermal {
> +	polling-delay-passive = <250>; /* milliseconds */
> +	polling-delay = <1000>; /* milliseconds */
> +
> +		/* sensor       ID */
^^ double tab here?
> +	thermal-sensors = <&bandgap     4>;
space after bandgap is good enough?
> +
> +	trips {
> +		iva_crit: iva_crit {
> +			temperature = <125000>; /* milliCelsius */
> +			hysteresis = <2000>; /* milliCelsius */
> +			type = THERMAL_TRIP_CRITICAL;
> +		};
> +	};
> +};

-- 
Regards,
Nishanth Menon
