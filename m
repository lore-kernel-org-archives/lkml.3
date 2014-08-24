Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaHXVig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 17:38:36 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57294 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaHXVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 17:38:34 -0400
Message-ID: <53FA5B55.4000603@gmail.com>
Date: Sun, 24 Aug 2014 23:38:29 +0200
From: Marcin Jabrzyk <marcin.jabrzyk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: mathieu.poirier@linaro.org, linus.walleij@linaro.org, will.deacon@arm.com,
        linux@arm.linux.org.uk, 00regkh@linuxfoundation.org
CC: pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, kaixu.xia@linaro.org,
        r.sengupta@samsung.com, robbelibobban@gmail.com,
        Tony.Armitstead@arm.com, daniel.thompson@linaro.org,
        patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11 v4] coresight: adding support for beagle and beagleXM
References: <1408554231-24321-1-git-send-email-mathieu.poirier@linaro.org> <1408554231-24321-10-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1408554231-24321-10-git-send-email-mathieu.poirier@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

W dniu 20.08.2014 o 19:03, mathieu.poirier@linaro.org pisze:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>
> Currently supporting ETM and ETB.  Support for TPIU
> and SDTI are yet to be added.
Did you tried running the drivers on board or are there any special
preparation needed?
I've BeagleBoard-xM Rev. C applied your patches and enabled the
functions the in menuconfig.
But on dmesg I see that:

[    0.685028] of_amba_device_create(): amba_device_add() failed (-19)
for /etb@5401b000
[    0.685119] of_amba_device_create(): amba_device_add() failed (-19)
for /etm@54010000

There are no nodes according coresight in /sys/kernel/debug/ .

Best regards,
Marcin

>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  arch/arm/boot/dts/omap3-beagle-xm.dts | 28 ++++++++++++++++++++++++++++
>  arch/arm/boot/dts/omap3-beagle.dts    | 28 ++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
>
> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
> index 1becefc..eec73d8 100644
> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> @@ -145,6 +145,34 @@
>  			};
>  		};
>  	};
> +
> +	etb@5401b000 {
> +		compatible = "arm,coresight-etb10", "arm,primecell";
> +		reg = <0x5401b000 0x1000>;
> +
> +		coresight-default-sink;
> +		clocks = <&emu_src_ck>;
> +		clock-names = "apb_pclk";
> +		port {
> +			etb_in: endpoint {
> +				slave-mode;
> +				remote-endpoint = <&etm_out>;
> +			};
> +		};
> +	};
> +
> +	etm@54010000 {
> +		compatible = "arm,coresight-etm3x", "arm,primecell";
> +		reg = <0x54010000 0x1000>;
> +
> +		clocks = <&emu_src_ck>;
> +		clock-names = "apb_pclk";
> +		port {
> +			etm_out: endpoint {
> +				remote-endpoint = <&etb_in>;
> +			};
> +		};
> +	};
>  };
>  
>  &omap3_pmx_wkup {
> diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
> index 3c3e6da..a151daf 100644
> --- a/arch/arm/boot/dts/omap3-beagle.dts
> +++ b/arch/arm/boot/dts/omap3-beagle.dts
> @@ -140,6 +140,34 @@
>  			};
>  		};
>  	};
> +
> +	etb@540000000 {
> +		compatible = "arm,coresight-etb10", "arm,primecell";
> +		reg = <0x5401b000 0x1000>;
> +
> +		coresight-default-sink;
> +		clocks = <&emu_src_ck>;
> +		clock-names = "apb_pclk";
> +		port {
> +			etb_in: endpoint {
> +				slave-mode;
> +				remote-endpoint = <&etm_out>;
> +			};
> +		};
> +	};
> +
> +	etm@54010000 {
> +		compatible = "arm,coresight-etm3x", "arm,primecell";
> +		reg = <0x54010000 0x1000>;
> +
> +		clocks = <&emu_src_ck>;
> +		clock-names = "apb_pclk";
> +		port {
> +			etm_out: endpoint {
> +				remote-endpoint = <&etb_in>;
> +			};
> +		};
> +	};
>  };
>  
>  &omap3_pmx_wkup {

