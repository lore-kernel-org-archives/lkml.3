Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3CTLaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:30:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38925 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab3CTLaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:30:17 -0400
Message-ID: <51499DB4.9080907@ti.com>
Date: Wed, 20 Mar 2013 16:59:56 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH v2 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
References: <1363761714-15034-1-git-send-email-avinashphilip@ti.com> <1363761714-15034-4-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1363761714-15034-4-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 3/20/2013 12:11 PM, Philip Avinash wrote:
> Add da850 EHRPWM & ECAP DT node.
> Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
> clock.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes since v1:
> 	- Reusing ti,am33xx<ecap/ehrpwm> as compatible field as both IP's are
> 	  same with am33xx platform and da850 has no platform specific
> 	  dependency.

Which is fine, but I think the binding documentation still needs to be
updated to document the ti,da850-ehrpwm binding. Looping Peter (it is
always a good idea to CC folks who reviewed your patch last time
around). Also, please Cc the DT folks and devicetree-discuss list too
for their opinion.

Thanks,
Sekhar

> 
> :100644 100644 3ec1bda... 62fd2d4... M	arch/arm/boot/dts/da850.dtsi
> :100644 100644 6b7a0a2... 89ee974... M	arch/arm/mach-davinci/da8xx-dt.c
>  arch/arm/boot/dts/da850.dtsi     |   30 ++++++++++++++++++++++++++++++
>  arch/arm/mach-davinci/da8xx-dt.c |    5 +++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index 3ec1bda..62fd2d4 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -107,6 +107,36 @@
>  			reg = <0x21000 0x1000>;
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
> index 6b7a0a2..89ee974 100644
> --- a/arch/arm/mach-davinci/da8xx-dt.c
> +++ b/arch/arm/mach-davinci/da8xx-dt.c
> @@ -40,6 +40,11 @@ static void __init da8xx_init_irq(void)
>  struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
>  	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
>  	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ehrpwm", 0x01f00000, "ehrpwm", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ehrpwm", 0x01f02000, "ehrpwm", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f06000, "ecap", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f07000, "ecap", NULL),
> +	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f08000, "ecap", NULL),
>  	{}
>  };
>  
> 
