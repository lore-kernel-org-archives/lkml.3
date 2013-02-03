Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab3BCMtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 07:49:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42050 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab3BCMtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 07:49:41 -0500
Message-ID: <510E5CC1.8050801@ti.com>
Date: Sun, 3 Feb 2013 18:19:05 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <anilkumar@ti.com>,
        <tony@atomide.com>, <hs@denx.de>,
        <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>,
        <khilman@deeprootsystems.com>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 3/6] ARM: davinci: da850: add DT node for I2C0
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com> <1359445134-13323-4-git-send-email-manishv.b@ti.com>
In-Reply-To: <1359445134-13323-4-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/29/2013 1:08 PM, Vishwanathrao Badarkhe, Manish wrote:
> Add I2C0 device tree node information to da850-evm.
> Also, add I2C0 pin muxing information in da850-evm.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> Changes since V1:
>  - Updated i2c0 node names in dts and dtsi file.
>  - Removed interrupt parent from i2c0 node.
>  - Handled i2c0 pin mux inside i2c0 node.
> 
> :100644 100644 433027f... c9ed683... M	arch/arm/boot/dts/da850-evm.dts
> :100644 100644 5e0eb5c... 245ab9a... M	arch/arm/boot/dts/da850.dtsi
>  arch/arm/boot/dts/da850-evm.dts |    5 +++++
>  arch/arm/boot/dts/da850.dtsi    |   15 +++++++++++++++
>  2 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index 433027f..c9ed683 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -27,6 +27,11 @@
>  		serial2: serial@1d0d000 {
>  			status = "okay";
>  		};
> +		i2c0: i2c0@1c22000 {

This should be:

i2c0: i2c@1c22000

inline with what has been done in rest of this file.

> +			status = "okay";
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&i2c0_pins>;
> +		};
>  	};
>  	nand_cs3@62000000 {
>  		status = "okay";
> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index 5e0eb5c..245ab9a 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -56,6 +56,12 @@
>  					0x30 0x01100000  0x0ff00000
>  				>;
>  			};
> +			i2c0_pins: pinmux_i2c0_pins {
> +				pinctrl-single,bits = <
> +					/* I2C0_SDA,I2C0_SCL */
> +					0x10 0x00002200 0x0000ff00
> +				>;
> +			};
>  		};
>  		serial0: serial@1c42000 {
>  			compatible = "ns16550a";
> @@ -81,6 +87,15 @@
>  			interrupts = <61>;
>  			status = "disabled";
>  		};
> +		i2c0: i2c0@1c22000 {
> +			compatible = "ti,davinci-i2c";
> +			reg = <0x22000 0x1000>;
> +			clock-frequency = <100000>;

The clock frequency is board specific. This should come from da850-evm.dts.

Also, I think you can merge the auxdata addition with this patch. Can
you post the i2c0 support separate from this series, so it can be taken
independently? Looks like other patches have some dependencies/acks needed.

Thanks,
Sekhar
