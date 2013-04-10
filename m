Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819Ab3DJLfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:35:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52857 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933890Ab3DJLfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:35:52 -0400
Message-ID: <51654E7C.5020107@ti.com>
Date: Wed, 10 Apr 2013 17:05:24 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <thierry.reding@avionic-design.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <jacmet@sunsite.dk>
Subject: Re: [PATCH v4] ARM: davinci: da850: add EHRPWM & ECAP DT node
References: <1365580939-16839-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1365580939-16839-1-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avinash,

On 4/10/2013 1:32 PM, Philip Avinash wrote:
> Add da850 EHRPWM & ECAP DT node along with pin-mux details for EHRPWM1.
> Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
> clock.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes since v3:
> 	- add pin mux info for EHRPWM1.

I think you misunderstood what I asked. Please add pinmux information
for all the nodes you are adding (ecap0-2 and ehrpwm0). Without pinmux
setup, these IPs cannot be used anyway. So why leave just the pinmux to
be added by someone else?

Thanks,
Sekhar

> 
> Changes since v1:
> 	- Reusing ti,am33xx<ecap/ehrpwm> as compatible field as both IP's are
> 	  similar with am33xx platform and da850 has no platform specific
> 	  dependency.
> 
>  arch/arm/boot/dts/da850.dtsi     |   42 ++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-davinci/da8xx-dt.c |    5 +++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index 3ade343..3bff30d 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -71,6 +71,18 @@
>  					0x28 0x00222222  0x00ffffff
>  				>;
>  			};
> +			ehrpwm1a_pins: pinmux_ehrpwm1a_pins {
> +				pinctrl-single,bits = <
> +					/* EPWM1A */
> +					0x14 0x00000002 0x0000000f
> +				>;
> +			};
> +			ehrpwm1b_pins: pinmux_ehrpwm1b_pins {
> +				pinctrl-single,bits = <
> +					/* EPWM1B */
> +					0x14 0x00000020 0x000000f0
> +				>;
> +			};
>  		};
>  		serial0: serial@1c42000 {
>  			compatible = "ns16550a";
> @@ -122,6 +134,36 @@
>  			interrupts = <16>;
>  			status = "disabled";
>  		};
> +		ehrpwm0: ehrpwm@01f00000 {
> +			compatible = "ti,da850-ehrpwm", "ti,am33xx-ehrpwm";
> +			#pwm-cells = <3>;
> +			reg = <0x300000 0x2000>;
> +			status = "disabled";
> +		};
> +		ehrpwm1: ehrpwm@01f02000 {
> +			compatible = "ti,da850-ehrpwm", "ti,am33xx-ehrpwm";
> +			#pwm-cells = <3>;
> +			reg = <0x302000 0x2000>;
> +			status = "disabled";
> +		};
> +		ecap0: ecap@01f06000 {
> +			compatible = "ti,da850-ecap", "ti,am33xx-ecap";
> +			#pwm-cells = <3>;
> +			reg = <0x306000 0x80>;
> +			status = "disabled";
> +		};
> +		ecap1: ecap@01f07000 {
> +			compatible = "ti,da850-ecap", "ti,am33xx-ecap";
> +			#pwm-cells = <3>;
> +			reg = <0x307000 0x80>;
> +			status = "disabled";
> +		};
> +		ecap2: ecap@01f08000 {
> +			compatible = "ti,da850-ecap", "ti,am33xx-ecap";
> +			#pwm-cells = <3>;
> +			reg = <0x308000 0x80>;
> +			status = "disabled";
> +		};
>  	};
>  	nand_cs3@62000000 {
>  		compatible = "ti,davinci-nand";
> diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
> index d83de8f..05bb9a2 100644
> --- a/arch/arm/mach-davinci/da8xx-dt.c
> +++ b/arch/arm/mach-davinci/da8xx-dt.c
> @@ -41,6 +41,11 @@ struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
>  	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
>  	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
>  	OF_DEV_AUXDATA("ti,da830-mmc", 0x01c40000, "da830-mmc.0", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ehrpwm", 0x01f00000, "ehrpwm", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ehrpwm", 0x01f02000, "ehrpwm", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f06000, "ecap", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f07000, "ecap", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f08000, "ecap", NULL),
>  	{}
>  };
>  
> 
