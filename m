Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3E1KMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:12:53 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:57380 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab3E1KMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:12:52 -0400
Date: Tue, 28 May 2013 11:12:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: Re: [PATCH 3/3] ARM: u8540: DT: Set pinctrl mapping to i2c0,1,2,4 & 5
Message-ID: <20130528101247.GM22683@gmail.com>
References: <1369661455-17839-1-git-send-email-gabriel.fernandez.st@gmail.com>
 <1369661455-17839-4-git-send-email-gabriel.fernandez.st@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369661455-17839-4-git-send-email-gabriel.fernandez.st@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013, Gabriel Fernandez wrote:

> From: Gabriel Fernandez <gabriel.fernandez@st.com>
> 
> This patch configures pin map in device tree of i2c0,
> 1,2,4 & 5 for ccu8540 board.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> ---
>  arch/arm/boot/dts/ccu8540-pinctrl.dtsi | 115 +++++++++++++++++++++++++++++++++

Okay, I'm starting to see the justification of this seperate file now.

>  arch/arm/boot/dts/ccu8540.dts          |  30 +++++++++
>  2 files changed, 145 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/ccu8540-pinctrl.dtsi b/arch/arm/boot/dts/ccu8540-pinctrl.dtsi
> index 26e718b..57e8165 100644
> --- a/arch/arm/boot/dts/ccu8540-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/ccu8540-pinctrl.dtsi
> @@ -74,4 +74,119 @@
>  			};
>  		};
>  	};
> +
> +	i2c0 {
> +		i2c0_default_mux: i2c_mux {
> +			default_mux {
> +				ste,function = "i2c0";

'stericsson'?

> +				ste,pins = "i2c0_a_1";
> +			};
> +		};
> +
> +		i2c0_default_mode: i2c_default {
> +			default_cfg1 {
> +				ste,pins = "GPIO147", "GPIO148";
> +				ste,config = <&in_pu>;
> +			};
> +		};
> +
> +		i2c0_sleep_mode: i2c_sleep {
> +			sleep_cfg1 {
> +				ste,pins = "GPIO147", "GPIO148";
> +				ste,config = <&slpm_in_pu>;
> +			};
> +		};
> +	};
> +
> +	i2c1 {
> +		i2c1_default_mux: i2c_mux {
> +			default_mux {
> +				ste,function = "i2c1";
> +				ste,pins = "i2c1_b_2";
> +			};
> +		};
> +
> +		i2c1_default_mode: i2c_default {
> +			default_cfg1 {
> +				ste,pins = "GPIO16", "GPIO17";
> +				ste,config = <&in_pu>;
> +			};
> +		};
> +
> +		i2c1_sleep_mode: i2c_sleep {
> +			sleep_cfg1 {
> +				ste,pins = "GPIO16", "GPIO17";
> +				ste,config = <&slpm_in_pu>;
> +			};
> +		};
> +	};
> +
> +	i2c2 {
> +		i2c2_default_mux: i2c_mux {
> +			default_mux {
> +				ste,function = "i2c2";
> +				ste,pins = "i2c2_b_2";
> +			};
> +		};
> +
> +		i2c2_default_mode: i2c_default {
> +			default_cfg1 {
> +				ste,pins = "GPIO10", "GPIO11";
> +				ste,config = <&in_pu>;
> +			};
> +		};
> +
> +		i2c2_sleep_mode: i2c_sleep {
> +			sleep_cfg1 {
> +				ste,pins = "GPIO11", "GPIO11";
> +				ste,config = <&slpm_in_pu>;
> +			};
> +		};
> +	};
> +
> +	i2c4 {
> +		i2c4_default_mux: i2c_mux {
> +			default_mux {
> +				ste,function = "i2c4";
> +				ste,pins = "i2c4_b_2";
> +			};
> +		};
> +
> +		i2c4_default_mode: i2c_default {
> +			default_cfg1 {
> +				ste,pins = "GPIO122", "GPIO123";
> +				ste,config = <&in_pu>;
> +			};
> +		};
> +
> +		i2c4_sleep_mode: i2c_sleep {
> +			sleep_cfg1 {
> +				ste,pins = "GPIO122", "GPIO123";
> +				ste,config = <&slpm_in_pu>;
> +			};
> +		};
> +	};
> +
> +	i2c5 {
> +		i2c5_default_mux: i2c_mux {
> +			default_mux {
> +				ste,function = "i2c5";
> +				ste,pins = "i2c5_c_2";
> +			};
> +		};
> +
> +		i2c5_default_mode: i2c_default {
> +			default_cfg1 {
> +				ste,pins = "GPIO118", "GPIO119";
> +				ste,config = <&in_pu>;
> +			};
> +		};
> +
> +		i2c5_sleep_mode: i2c_sleep {
> +			sleep_cfg1 {
> +				ste,pins = "GPIO118", "GPIO119";
> +				ste,config = <&slpm_in_pu>;
> +			};
> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
> index 4f93795..3e7142b 100644
> --- a/arch/arm/boot/dts/ccu8540.dts
> +++ b/arch/arm/boot/dts/ccu8540.dts
> @@ -44,5 +44,35 @@
>  			pinctrl-1 = <&uart2_sleep_mode>;
>  			status = "okay";
>  		};
> +
> +		i2c0: i2c@80004000 {
> +			pinctrl-names = "default","sleep";

Can you place a ' ' after the ','?

> +			pinctrl-0 = <&i2c0_default_mux>,<&i2c0_default_mode>;

All the way down ...

> +			pinctrl-1 = <&i2c0_sleep_mode>;
> +		};
> +
> +		i2c1: i2c@80122000 {
> +			pinctrl-names = "default","sleep";
> +			pinctrl-0 = <&i2c1_default_mux>,<&i2c1_default_mode>;
> +			pinctrl-1 = <&i2c1_sleep_mode>;
> +		};
> +
> +		i2c2: i2c@80128000 {
> +			pinctrl-names = "default","sleep";
> +			pinctrl-0 = <&i2c2_default_mux>,<&i2c2_default_mode>;
> +			pinctrl-1 = <&i2c2_sleep_mode>;
> +		};
> +
> +		i2c4: i2c@8012a000 {
> +			pinctrl-names = "default","sleep";
> +			pinctrl-0 = <&i2c4_default_mux>,<&i2c4_default_mode>;
> +			pinctrl-1 = <&i2c4_sleep_mode>;
> +		};
> +
> +		i2c5: i2c@80001000 {
> +			pinctrl-names = "default","sleep";
> +			pinctrl-0 = <&i2c5_default_mux>,<&i2c5_default_mode>;
> +			pinctrl-1 = <&i2c5_sleep_mode>;
> +		};
>  	};
>  };

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
