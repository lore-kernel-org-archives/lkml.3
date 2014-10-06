Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaJFUsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:48:20 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:49929 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaJFUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:48:18 -0400
Date: Mon, 6 Oct 2014 21:48:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] mfd: max77693: Update DT binding to support haptic
Message-ID: <20141006204812.GC18035@lee--X1>
References: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
 <1410972026-25189-4-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410972026-25189-4-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Jaewon Kim wrote:

> This patch add haptic DT binding documentation and example
> to support haptic driver in max77693 Multifunction device.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max77693.txt |   21 ++++++++++++++++++++
>  1 file changed, 21 insertions(+)

Applied for v3.19.

> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
> index 11921cc..01e9f30 100644
> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
> @@ -27,6 +27,20 @@ Optional properties:
>  
>  	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
>  
> +- haptic : The MAX77693 haptic device utilises a PWM controlled motor to provide
> +  users with tactile feedback. PWM period and duty-cycle are varied in
> +  order to provide the approprite level of feedback.
> +
> + Required properties:
> +	- compatible : Must be "maxim,max77693-hpatic"
> +	- haptic-supply : power supply for the haptic motor
> +	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
> +	- pwms : phandle to the physical PWM(Pulse Width Modulation) device.
> +	 PWM properties should be named "pwms". And number of cell is different
> +	 for each pwm device.
> +	 To get more informations, please refer to documentaion.
> +	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
> +
>  Example:
>  	max77693@66 {
>  		compatible = "maxim,max77693";
> @@ -52,4 +66,11 @@ Example:
>  					regulator-boot-on;
>  			};
>  		};
> +
> +		haptic {
> +			compatible = "maxim,max77693-haptic";
> +			haptic-supply = <&haptic_supply>;
> +			pwms = <&pwm 0 40000 0>;
> +			pwm-names = "haptic";
> +		};
>  	};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
