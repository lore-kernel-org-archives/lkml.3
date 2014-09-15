Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbaIOXAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:00:49 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:43342 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759858AbaIOXAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:00:47 -0400
Date: Tue, 16 Sep 2014 00:00:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 4/4] mfd: max77693: Update DT binding to support haptic
Message-ID: <20140915230043.GI25162@lee--X1>
References: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
 <1410440062-19963-5-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410440062-19963-5-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Jaewon Kim wrote:

> This patch add haptic DT binding documentation and example
> to support haptic driver in max77693 Multifunction device.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max77693.txt |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
> index 11921cc..d178b9e 100644
> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
> @@ -27,6 +27,17 @@ Optional properties:
>  
>  	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
>  
> +- haptic : The haptic of max77693 have to be instantiated under subnod

Perhaps a description as to what "The haptic" is might be handy?

s/have/has

s/subnod/subnode

What do you mean by "under" a subnode?  Do you mean "as a" subnode?

> +  named "haptic" using the following haptic format in example.

What is the "haptic format"?  It just looks like a normal node to me.

> +  Haptic sensation from motor can be changed by changing a period cycle in pwms.

Is "Haptic sensation" a technical term?

s/from motor/from a motor/

s/changed by changing/changed by varying/

s/period cycle/duty cycle/

s/in pwms/in the pwms property/

> +
> + Required properties:
> +	- compatible : Must be "maxim,max77693-hpatic"
> +	- haptic-supply : power supply for haptic motor

s/for haptic/for the haptic/

> +		[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
> +	- pwms : phandle to the physical PWM device,

It's not just the phandle though is it?

> +		[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
> +
>  Example:
>  	max77693@66 {
>  		compatible = "maxim,max77693";
> @@ -52,4 +63,11 @@ Example:
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
