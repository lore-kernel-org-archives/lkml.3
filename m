Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3LTNsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:48:17 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60384 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab3LTNsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:48:15 -0500
Date: Fri, 20 Dec 2013 13:48:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: anton@enomsg.org, dwmw2@infradead.org, mark.rutland@arm.com,
        rob@landley.net, ijc+devicetree@hellion.org.uk, swarren@nvidia.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] mfd: AS3722: add dt node properties for system
 power controller
Message-ID: <20131220134808.GD3709@lee--X1>
References: <1387545840-2844-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387545840-2844-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013, Laxman Dewangan wrote:

> ams AS3722 device supports the power off by turning off its all rails.
> 
> Add dt node properties to enable this functionality on this device.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>

I'm guessing I can use this as an Ack?

> ---
> Changes form V1:
> - Rephrase sentence and mention that propery is boolean type.
> - Added Tested by.
> 
>  Documentation/devicetree/bindings/mfd/as3722.txt |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
> index fc2191e..8edcb9b 100644
> --- a/Documentation/devicetree/bindings/mfd/as3722.txt
> +++ b/Documentation/devicetree/bindings/mfd/as3722.txt
> @@ -112,6 +112,15 @@ Following are properties of regulator subnode.
>  		ams,enable-tracking: Enable tracking with SD1, only supported
>  			by LDO3.
>  
> +Power-off:
> +=========
> +AS3722 supports the system power off by turning off all its rail. This
> +is provided through pm_power_off.
> +The device node should have the following properties to enable this
> +functionality
> +ams,system-power-controller: Boolean, to enable the power off functionality
> +        through this device.
> +
>  Example:
>  --------
>  #include <dt-bindings/mfd/as3722.h>
> @@ -120,6 +129,8 @@ ams3722 {
>  	compatible = "ams,as3722";
>  	reg = <0x48>;
>  
> +	ams,system-power-controller;
> +
>  	interrupt-parent = <&intc>;
>  	interrupt-controller;
>  	#interrupt-cells = <2>;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
