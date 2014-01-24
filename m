Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaAXRCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:02:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaAXRCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:02:20 -0500
Message-ID: <1390582906.12454.26.camel@deneb.redhat.com>
Subject: Re: [PATCH 2/5] arm64: dts: APM X-Gene SoC Ethernet device tree
 nodes
From: Mark Salter <msalter@redhat.com>
To: Iyappan Subramanian <isubramanian@apm.com>
Cc: davem@davemloft.net, gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Date: Fri, 24 Jan 2014 12:01:46 -0500
In-Reply-To: <1387597376-29303-3-git-send-email-isubramanian@apm.com>
References: <1387597376-29303-1-git-send-email-isubramanian@apm.com>
	 <1387597376-29303-3-git-send-email-isubramanian@apm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 19:42 -0800, Iyappan Subramanian wrote:
> Device tree files for APM X-Gene SoC Ethernet.
> 
> Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
> Signed-off-by: Ravi Patel <rapatel@apm.com>
> Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
> ---
>  arch/arm64/boot/dts/apm-mustang.dts |    8 ++++++++
>  arch/arm64/boot/dts/apm-storm.dtsi  |   19 +++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/apm-mustang.dts b/arch/arm64/boot/dts/apm-mustang.dts
> index 1247ca1..ccb2771 100644
> --- a/arch/arm64/boot/dts/apm-mustang.dts
> +++ b/arch/arm64/boot/dts/apm-mustang.dts
> @@ -17,6 +17,10 @@
>  	model = "APM X-Gene Mustang board";
>  	compatible = "apm,mustang", "apm,xgene-storm";
>  
> +        aliases {
> +                ethernet0 = &menet;
> +        };
> +
>  	chosen { };
>  
>  	memory {
> @@ -24,3 +28,7 @@
>  		reg = < 0x1 0x00000000 0x0 0x80000000 >; /* Updated by bootloader */
>  	};
>  };
> +
> +&menet {
> +        status = "ok";
> +};
> diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
> index f64f946..9c7b8cd 100644
> --- a/arch/arm64/boot/dts/apm-storm.dtsi
> +++ b/arch/arm64/boot/dts/apm-storm.dtsi
> @@ -204,5 +204,24 @@
>  			#clock-cells = <1>;
>  			clocks = <&qmlclk 0>;
>  		};
> +
> +		menet: ethernet@17020000 {
> +			compatible = "apm,xgene-enet";
> +			status = "disabled";
> +			reg = <0x0 0x17020000 0x0 0x30>,
> +			      <0x0 0x17020000 0x0 0x10000>,
> +			      <0x0 0x17020000 0x0 0x20>;
> +			slave-name = "RGMII";
> +			interrupts = <0x0 0x38 0x4>,
> +				     <0x0 0x39 0x4>,
> +				     <0x0 0x3a 0x4>;
> +			#clock-cells = <1>;
> +			clocks = <&eth8clk 0>;
> +			local-mac-address = <0x0 0x11 0x3a 0x8a 0x5a 0x78>;

Shouldn't this be a byte string?:

			local-mac-address = [ 00 11 3a 8a 5a 78 ];

> +			max-frame-size = <0x233a>;
> +			devid = <8>;
> +			phyid = <3>;
> +			phy-mode = "rgmii";
> +		};
>  	};
>  };


