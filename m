Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaBTQgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:36:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35496 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbaBTQgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:36:37 -0500
Message-ID: <53062EFB.3080501@ti.com>
Date: Thu, 20 Feb 2014 10:36:11 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 3/4] ARM: dts: OMAP5: Add device nodes for ABB
References: <1391039177-25284-1-git-send-email-nm@ti.com> <1391039177-25284-4-git-send-email-nm@ti.com>
In-Reply-To: <1391039177-25284-4-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2014 05:46 PM, Nishanth Menon wrote:
> From: "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>
> 
> Add ABB device nodes for OMAP5 family of devices. Data is based on
> OMAP543x Technical Reference Manual revision U (April 2013).
> NOTE: clock node has been disabled in this patch due to the lack of
> OMAP5 clock data.
> 
> [nm@ti.com: co-developer]
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Andrii.Tseglytskyi <andrii.tseglytskyi@ti.com>
> ---

I have been informed that there is an fix in TI official documentation
which is due end of this month. So, I have to drop this patch from the
series for the time being - I will refresh this along with necessary
OMAP5 updates once the official documentation is available.

>  arch/arm/boot/dts/omap5.dtsi |   63 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index a72813a..6159f20 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -801,6 +801,69 @@
>  
>  			#thermal-sensor-cells = <1>;
>  		};
> +
> +		abb_mpu: regulator-abb-mpu {
> +			compatible = "ti,abb-v2";
> +			regulator-name = "abb_mpu";
> +			#address-cells = <0>;
> +			#size-cells = <0>;
> +			clocks = <&sys_clkin>;
> +			ti,settling-time = <50>;
> +			ti,clock-cycles = <16>;
> +
> +			reg = <0x4ae07cdc 0x8>, <0x4ae06014 0x4>,
> +			      <0x4a0021ac 0x18>, <0x4ae0C318 0x4>;
> +			reg-names = "base-address", "int-address",
> +				    "efuse-address", "ldo-address";
> +			ti,tranxdone-status-mask = <0x80>;
> +			/* LDOVBBMPU_MUX_CTRL */
> +			ti,ldovbb-override-mask = <0x400>;
> +			/* LDOVBBMPU_VSET_OUT */
> +			ti,ldovbb-vset-mask = <0x1F>;
> +
> +			/*
> +			 * NOTE: only FBB mode used but actual vset will
> +			 * determine final biasing
> +			 */
> +			ti,abb_info = <
> +			/*uV		ABB	efuse	rbb_m fbb_m	vset_m*/
> +			880000		0	0x4	0 0x20000000 0x1F000000
> +			1060000		0	0x8	0 0x20000000 0x1F000000
> +			1250000		0	0x10	0 0x20000000 0x1F000000
> +			1260000		1	0x14	0 0x20000000 0x1F000000
> +			>;
> +		};
> +
> +		abb_mm: regulator-abb-mm {
> +			compatible = "ti,abb-v2";
> +			regulator-name = "abb_mm";
> +			#address-cells = <0>;
> +			#size-cells = <0>;
> +			clocks = <&sys_clkin>;
> +			ti,settling-time = <50>;
> +			ti,clock-cycles = <16>;
> +
> +			reg = <0x4ae07ce4 0x8>, <0x4ae06010 0x4>,
> +			      <0x4a002194 0x14>, <0x4ae0C314 0x4>;
> +			reg-names = "base-address", "int-address",
> +				    "efuse-address", "ldo-address";
> +			ti,tranxdone-status-mask = <0x80000000>;
> +			/* LDOVBBMM_MUX_CTRL */
> +			ti,ldovbb-override-mask = <0x400>;
> +			/* LDOVBBMM_VSET_OUT */
> +			ti,ldovbb-vset-mask = <0x1F>;
> +
> +			/*
> +			 * NOTE: only FBB mode used but actual vset will
> +			 * determine final biasing
> +			 */
> +			ti,abb_info = <
> +			/*uV		ABB	efuse	rbb_m fbb_m	vset_m*/
> +			880000		0	0x4	0 0x20000000 0x1F000000
> +			1025000		0	0x8	0 0x20000000 0x1F000000
> +			1120000		1	0x10	0 0x20000000 0x1F000000
> +			>;
> +		};
>  	};
>  };
>  
> 


-- 
Regards,
Nishanth Menon
