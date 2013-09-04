Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798Ab3IDMkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:40:00 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50111 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934439Ab3IDMj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:39:58 -0400
Date: Wed, 4 Sep 2013 13:38:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 02/11] ARM: ux500: Enable the LPS001WP Pressure &
 Temperature sensor from DT
Message-ID: <20130904123850.GI18206@e106331-lin.cambridge.arm.com>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378287103-21765-3-git-send-email-lee.jones@linaro.org>
Thread-Topic: [PATCH 02/11] ARM: ux500: Enable the LPS001WP Pressure &
 Temperature sensor from DT
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed, Sep 04, 2013 at 10:31:34AM +0100, Lee Jones wrote:
> After applying this node the LPS001WP sensor chip should probe
> successfully once the driver support has also been applied.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/ste-snowball.dts | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
> index cf9b16e..aad8f54 100644
> --- a/arch/arm/boot/dts/ste-snowball.dts
> +++ b/arch/arm/boot/dts/ste-snowball.dts
> @@ -153,6 +153,16 @@
>  			status = "okay";
>  		};
>  
> +		i2c@80128000 {
> +			lps001wp@5c {
> +				compatible = "lps001wp";
> +				reg = <0x5c>;
> +
> +				vdd-supply = <&ab8500_ldo_aux1_reg>;
> +				vms-supply = <&db8500_vsmps2_reg>;
> +			};
> +		};
> +

This appears to be missing a binding document. I couldn't see one
anywhere in this series, or in mainline already).

As far as I can see, the compatible string should be "st,lps001wp".

Please produce a binding document.

Is there any publicly available documentation on the chip?

Thanks,
Mark.

>  		uart@80120000 {
>  			status = "okay";
>  		};
> -- 
> 1.8.1.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
