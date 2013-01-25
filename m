Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3AYKup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:50:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40873 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab3AYKun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:50:43 -0500
Message-ID: <51026365.1020402@ti.com>
Date: Fri, 25 Jan 2013 16:20:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <sameo@linux.intel.com>, <tony@atomide.com>,
        <broonie@opensource.wolfsonmicro.com>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <rob@landley.net>, <anilkumar@ti.com>,
        <hs@denx.de>
Subject: Re: [PATCH 2/6] ARM: davinci: da850: add DT node for I2C0
References: <1359027324-14534-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1359027324-14534-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/2013 5:05 PM, Vishwanathrao Badarkhe, Manish wrote:
> Add I2C0 device tree node information to da850-evm.
> Also, add I2C0 pin muxing information in da850-evm.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> Depends on patch 
> http://comments.gmane.org/gmane.linux.davinci/25993
> 
>  arch/arm/boot/dts/da850-evm.dts |   15 +++++++++++++++
>  arch/arm/boot/dts/da850.dtsi    |   10 ++++++++++
>  2 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index 8cac9d2..3d8290a 100755
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -27,5 +27,20 @@
>  		serial2: serial@1d0d000 {
>  			status = "okay";
>  		};
> +		i2c0@1c22000 {

This should be
		i2c0: i2c@1c22000

to follow the convention elsewhere in file.

> +			status = "okay";
> +		};
> +	};
> +};
> +&pmx_core {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <
> +		&i2c0_pins
> +	>;
> +
> +	i2c0_pins: pinmux_i2c0_pins{
> +		pinctrl-single,bits = <
> +			0x10 0x00002200 0x0000ff00	/* I2C0_SDA,I2C0_SCL */
> +		>;

This should go into the dtsi file. See the discussion on NAND DT support
submitted by Anil Kumar.

Thanks,
Sekhar

PS: You are using an old address for Kevin Hilman. The MAINTAINERS file
has been updated for a long time now. Liam's address is also wrong but I
don't have his updated e-mail.
