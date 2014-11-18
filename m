Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaKRITu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:19:50 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:56338 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaKRITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:19:48 -0500
Date: Tue, 18 Nov 2014 08:19:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it,
        lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 5/5] mfd: s2mps11: Add binding documentation for Samsung
 S2MPS13 PMIC
Message-ID: <20141118081942.GT24004@x1>
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-6-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416184980-532-6-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Chanwoo Choi wrote:

> This patch adds the binding documentation for Samsung S2MPS13 PMIC
> which is similiar with existing S2MPS14 PMIC. S2MPS13 has the different number
> of regulators from S2MPS14 and RTC/Clock is the same with the S2MPS14.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)

For my reference:

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> index 0e4026a..57a0450 100644
> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> @@ -1,5 +1,5 @@
>  
> -* Samsung S2MPS11, S2MPS14 and S2MPU02 Voltage and Current Regulator
> +* Samsung S2MPS11, S2MPS13, S2MPS14 and S2MPU02 Voltage and Current Regulator
>  
>  The Samsung S2MPS11 is a multi-function device which includes voltage and
>  current regulators, RTC, charger controller and other sub-blocks. It is
> @@ -7,8 +7,8 @@ interfaced to the host controller using an I2C interface. Each sub-block is
>  addressed by the host system using different I2C slave addresses.
>  
>  Required properties:
> -- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic"
> -              or "samsung,s2mpu02-pmic".
> +- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps13-pmic"
> +	      or "samsung,s2mps14-pmic" or "samsung,s2mpu02-pmic".
>  - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
>  
>  Optional properties:
> @@ -17,8 +17,8 @@ Optional properties:
>  - interrupts: Interrupt specifiers for interrupt sources.
>  
>  Optional nodes:
> -- clocks: s2mps11 and s5m8767 provide three(AP/CP/BT) buffered 32.768 KHz
> -  outputs, so to register these as clocks with common clock framework
> +- clocks: s2mps11, s2mps13 and s5m8767 provide three(AP/CP/BT) buffered 32.768
> +  KHz outputs, so to register these as clocks with common clock framework
>    instantiate a sub-node named "clocks". It uses the common clock binding
>    documented in :
>    [Documentation/devicetree/bindings/clock/clock-bindings.txt]
> @@ -30,12 +30,12 @@ Optional nodes:
>      the clock which they consume.
>      Clock               ID           Devices
>      ----------------------------------------------------------
> -    32KhzAP		0            S2MPS11, S2MPS14, S5M8767
> -    32KhzCP		1            S2MPS11, S5M8767
> -    32KhzBT		2            S2MPS11, S2MPS14, S5M8767
> +    32KhzAP		0            S2MPS11, S2MPS13, S2MPS14, S5M8767
> +    32KhzCP		1            S2MPS11, S2MPS13, S5M8767
> +    32KhzBT		2            S2MPS11, S2MPS13, S2MPS14, S5M8767
>  
> -  - compatible: Should be one of: "samsung,s2mps11-clk", "samsung,s2mps14-clk",
> -		"samsung,s5m8767-clk"
> +  - compatible: Should be one of: "samsung,s2mps11-clk", "samsung,s2mps13-clk",
> +		"samsung,s2mps14-clk", "samsung,s5m8767-clk"
>  
>  - regulators: The regulators of s2mps11 that have to be instantiated should be
>  included in a sub-node named 'regulators'. Regulator nodes included in this
> @@ -81,12 +81,14 @@ as per the datasheet of s2mps11.
>  	- LDOn
>  		  - valid values for n are:
>  			- S2MPS11: 1 to 38
> +			- S2MPS13: 1 to 40
>  			- S2MPS14: 1 to 25
>  			- S2MPU02: 1 to 28
>  		  - Example: LDO1, LDO2, LDO28
>  	- BUCKn
>  		  - valid values for n are:
>  			- S2MPS11: 1 to 10
> +			- S2MPS13: 1 to 10
>  			- S2MPS14: 1 to 5
>  			- S2MPU02: 1 to 7
>  		  - Example: BUCK1, BUCK2, BUCK9

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
