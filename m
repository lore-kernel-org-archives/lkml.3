Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbbAIIjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:39:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14632 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbbAIIjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:39:15 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-81-54af93b09cd7
Message-id: <1420792751.553.1.camel@AMDC1943>
Subject: Re: [PATCH v5 5/5] ARM: dts: exynos4412-trats: Switch max77686
 regulators to GPIO control
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Date: Fri, 09 Jan 2015 09:39:11 +0100
In-reply-to: <1420458525-22576-6-git-send-email-k.kozlowski@samsung.com>
References: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
 <1420458525-22576-6-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xK7obJq8PMVj4V9pi44z1rBZTHz5h
	s5h/5ByrRf/j18wWZ5vesFt8u9LBZLHp8TVWi8u75rBZzDi/j8mB02PnrLvsHptWdbJ5bF5S
	79G3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZ3UsKCzbKVLTM28DawNgq1sXIwSEhYCLx6IVO
	FyMnkCkmceHeerYuRi4OIYGljBKX+rexQzifGSXuz57ADFLFK6Ar0fz8EAtIs7BAisSk+/Ug
	YTYBY4nNy5ewgYRFBBQlNi9QAGllFtjCJPF89TR2kDiLgKrEzRsOIOWcAh4Sp1evZoEY38oo
	Me3dalaQBLOAusSkeYuYIW5Tlmjsd4PYKijxY/I9FogSeYnNa94yT2AUmIWkYxaSsllIyhYw
	Mq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAn4LzsYFx+zOsQowMGoxMO7Q3V9iBBrYllx
	Ze4hRgkOZiUR3kMTgEK8KYmVValF+fFFpTmpxYcYmTg4pRoYA0qDNrw+fPfZzvc209/lz/rw
	ynhqXIOQWk9ALPuEixtlX/bPtbxy56jos+dh044vd1GKaOk81Xj+2uqiopOFX0oLnTUXe7Yc
	/2B/+WpJ8pqDyiaCiy+lMwcdztQMDa3wLWRxq9t+s7rq29JTzE3B0jmt301u9fl17Hn840Jk
	7rNI3fCQDfoHlViKMxINtZiLihMBrMni+lYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

Mark Brown pulled regulator changes and documentation for bindings [1].
Could you pick up this patch?

[1] http://www.spinics.net/lists/linux-samsung-soc/msg40834.html

Best regards,
Krzysztof


On pon, 2015-01-05 at 12:48 +0100, Krzysztof Kozlowski wrote:
> Remove fixed regulators (duplicating what max77686 provides) and
> add GPIO enable control to max77686 regulators.
> 
> This gives the system full control over those regulators. Previously
> the state of such regulators was a mixture of what max77686 driver set
> over I2C and what regulator-fixed set through GPIO.
> 
> Removal of 'regulator-always-on' from CAM_ISP_CORE_1.2V (buck9) allows
> disabling it when it is not used. Previously this regulator was always
> enabled because its enable state is a OR of:
>  - ENB9 GPIO (turned always on by regulator-fixed),
>  - BUCK9EN field in BUCK9CTRL register (off by max77686 through I2C).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4412-trats2.dts | 25 +++++--------------------
>  1 file changed, 5 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> index 405d4f337e89..186c210680c1 100644
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> @@ -58,15 +58,6 @@
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  
> -		vemmc_reg: regulator-0 {
> -			compatible = "regulator-fixed";
> -			regulator-name = "VMEM_VDD_2.8V";
> -			regulator-min-microvolt = <2800000>;
> -			regulator-max-microvolt = <2800000>;
> -			gpio = <&gpk0 2 0>;
> -			enable-active-high;
> -		};
> -
>  		cam_io_reg: voltage-regulator-1 {
>  			compatible = "regulator-fixed";
>  			regulator-name = "CAM_SENSOR_A";
> @@ -94,16 +85,6 @@
>  			enable-active-high;
>  		};
>  
> -		cam_isp_core_reg: voltage-regulator-4 {
> -			compatible = "regulator-fixed";
> -			regulator-name = "CAM_ISP_CORE_1.2V_EN";
> -			regulator-min-microvolt = <1200000>;
> -			regulator-max-microvolt = <1200000>;
> -			gpio = <&gpm0 3 0>;
> -			enable-active-high;
> -			regulator-always-on;
> -		};
> -
>  		ps_als_reg: voltage-regulator-5 {
>  			compatible = "regulator-fixed";
>  			regulator-name = "LED_A_3.0V";
> @@ -405,6 +386,7 @@
>  					regulator-name = "VTF_2.8V";
>  					regulator-min-microvolt = <2800000>;
>  					regulator-max-microvolt = <2800000>;
> +					maxim,ena-gpios = <&gpy2 0 GPIO_ACTIVE_HIGH>;
>  				};
>  
>  				ldo22_reg: ldo22 {
> @@ -412,6 +394,7 @@
>  					regulator-name = "VMEM_VDD_2.8V";
>  					regulator-min-microvolt = <2800000>;
>  					regulator-max-microvolt = <2800000>;
> +					maxim,ena-gpios = <&gpk0 2 GPIO_ACTIVE_HIGH>;
>  				};
>  
>  				ldo23_reg: ldo23 {
> @@ -518,6 +501,7 @@
>  					regulator-name = "VMEM_VDDF_3.0V";
>  					regulator-min-microvolt = <2850000>;
>  					regulator-max-microvolt = <2850000>;
> +					maxim,ena-gpios = <&gpk0 2 GPIO_ACTIVE_HIGH>;
>  				};
>  
>  				buck9_reg: buck9 {
> @@ -525,6 +509,7 @@
>  					regulator-name = "CAM_ISP_CORE_1.2V";
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1200000>;
> +					maxim,ena-gpios = <&gpm0 3 GPIO_ACTIVE_HIGH>;
>  				};
>  			};
>  		};
> @@ -587,7 +572,7 @@
>  		broken-cd;
>  		non-removable;
>  		card-detect-delay = <200>;
> -		vmmc-supply = <&vemmc_reg>;
> +		vmmc-supply = <&ldo22_reg>;
>  		clock-frequency = <400000000>;
>  		samsung,dw-mshc-ciu-div = <0>;
>  		samsung,dw-mshc-sdr-timing = <2 3>;

