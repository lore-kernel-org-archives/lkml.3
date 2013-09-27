Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3I0M0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:26:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38970 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab3I0M02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:26:28 -0400
Date: Fri, 27 Sep 2013 07:24:39 -0500
From: Nishanth Menon <nm@ti.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <devicetree@vger.kernel.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        <grant.likely@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 11/18] arm: dts: add omap4430 thermal data
Message-ID: <20130927122439.GA8360@kahuna>
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
 <1380251605-3804-12-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380251605-3804-12-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:13-20130926, Eduardo Valentin wrote:
> This patch changes the dtsi entry on omap4430 to contain
> the thermal data. This data will enable the passive
> cooling with CPUfreq cooling device at 100C and the
> system will do a thermal shutdown at 125C.
> 
> Cc: "Benoît Cousson" <bcousson@baylibre.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-omap@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  arch/arm/boot/dts/omap443x.dtsi | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
> index bcf455e..e9c97d6 100644
> --- a/arch/arm/boot/dts/omap443x.dtsi
> +++ b/arch/arm/boot/dts/omap443x.dtsi
> @@ -12,7 +12,7 @@
>  
>  / {
>  	cpus {
> -		cpu@0 {
> +		cpu0: cpu@0 {
>  			/* OMAP443x variants OPP50-OPPNT */
>  			operating-points = <
>  				/* kHz    uV */
> @@ -25,9 +25,15 @@
>  		};
>  	};
>  
> -	bandgap {
> +	thermal-zones{
> +		#include "omap4-cpu-thermal.dtsi"
> +	};
> +
> +	bandgap: bandgap {
>  		reg = <0x4a002260 0x4
>  		       0x4a00232C 0x4>;
>  		compatible = "ti,omap4430-bandgap";
> +
> +		#thermal-sensor-cells = <0>;
2 cents:
we might want to move bandgap under ocp?

>  	};
>  };
> -- 
> 1.8.2.1.342.gfa7285d
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Regards,
Nishanth Menon
