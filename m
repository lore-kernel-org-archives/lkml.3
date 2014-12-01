Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaLAU0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:26:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191AbaLAU0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:26:16 -0500
Message-ID: <547CCEE3.6020806@suse.de>
Date: Mon, 01 Dec 2014 21:26:11 +0100
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH] ARM: zynq: DT: Add USB to device tree
References: <1417459352-23401-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1417459352-23401-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sören,

Am 01.12.2014 um 19:42 schrieb Soren Brinkmann:
> Add USB nodes to zc702, zc706 and zed device trees.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 22 +++++++++++++++++++++-
>  arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
>  arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
>  arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
>  4 files changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index ce2ef5bec4f2..9ed60938f301 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -315,6 +315,26 @@
>  			clocks = <&clkc 4>;
>  		};
>  
> +		usb0: usb@e0002000 {
> +			compatible = "xlnx,zynq-usb-2.20a", "chipidea,usb2";
> +			status = "disabled";
> +			clocks = <&clkc 28>;
> +			interrupt-parent = <&intc>;
> +			interrupts = <0 21 4>;
> +			reg = <0xe0002000 0x1000>;
> +			phy_type = "ulpi";
> +		};
> +
> +		usb1: usb@e0003000 {
> +			compatible = "xlnx,zynq-usb-2.20a", "chipidea,usb2";
> +			status = "disabled";
> +			clocks = <&clkc 29>;
> +			interrupt-parent = <&intc>;
> +			interrupts = <0 44 4>;
> +			reg = <0xe0003000 0x1000>;
> +			phy_type = "ulpi";
> +		};
> +
>  		watchdog0: watchdog@f8005000 {
>  			clocks = <&clkc 45>;
>  			compatible = "xlnx,zynq-wdt-r1p2";

This part looks good.

> @@ -324,6 +344,6 @@
>  			reg = <0xf8005000 0x1000>;
>  			reset = <0>;
>  			timeout-sec = <10>;
> -		};
> +		} ;
>  	};
>  };

Unrelated accidental change here though. :)

Did I miss a matching series actually implementing the driver? I'd need
to test the latest version to determine how to update the Parallella
device tree - I assume that USB0 is in dr_mode="host", but with the
previous patchsets I was unable to verify. CC'ing Ola.

Regards,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
