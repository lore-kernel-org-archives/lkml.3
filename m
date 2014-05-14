Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaENNTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbaENNTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:19:37 -0400
Message-ID: <53736D0B.5070600@redhat.com>
Date: Wed, 14 May 2014 15:18:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexander Bersenev <bay@hackerdom.ru>, linux-sunxi@googlegroups.com,
        david@hardeman.nu, devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, pawel.moll@arm.com,
        rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
        srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v6 3/3] ARM: sunxi: Add IR controller support in DT on
 A20
References: <1400006342-2968-1-git-send-email-bay@hackerdom.ru> <1400006342-2968-4-git-send-email-bay@hackerdom.ru>
In-Reply-To: <1400006342-2968-4-git-send-email-bay@hackerdom.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

<snip>

On 05/13/2014 08:39 PM, Alexander Bersenev wrote:
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
> index 0ae2b77..40ded74 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -724,6 +724,19 @@
>  				allwinner,drive = <2>;
>  				allwinner,pull = <0>;
>  			};
> +
> +			ir0_pins_a: ir0@0 {
> +				    allwinner,pins = "PB3","PB4";
> +				    allwinner,function = "ir0";
> +				    allwinner,drive = <0>;
> +				    allwinner,pull = <0>;
> +			};
> +			ir1_pins_a: ir1@0 {
> +				    allwinner,pins = "PB22","PB23";
> +				    allwinner,function = "ir1";
> +				    allwinner,drive = <0>;
> +				    allwinner,pull = <0>;
> +			};
>  		};
>  
>  		timer@01c20c00 {
> @@ -937,5 +950,23 @@
>  			#interrupt-cells = <3>;
>  			interrupts = <1 9 0xf04>;
>  		};
> +
> +		ir0: ir@01c21800 {
> +			compatible = "allwinner,sun7i-a20-ir";
> +			clocks = <&apb0_gates 6>, <&ir0_clk>;
> +			clock-names = "apb", "ir";
> +			interrupts = <0 5 4>;
> +			reg = <0x01c21800 0x40>;
> +			status = "disabled";
> +		};
> +
> +		ir1: ir@01c21c00 {
> +			compatible = "allwinner,sun7i-a20-ir";
> +			clocks = <&apb0_gates 7>, <&ir1_clk>;
> +			clock-names = "apb", "ir";
> +			interrupts = <0 6 4>;
> +			reg = <0x01C21c00 0x40>;
> +			status = "disabled";
> +		};
>  	};
>  };
> 

The entries in the soc block are sorted by register address, so please
don't add these at the end, instead keep things sorted.

Regards,

Hans
