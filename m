Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaLCIkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:40:05 -0500
Received: from mail-bl2on0096.outbound.protection.outlook.com ([65.55.169.96]:7488
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751149AbaLCIkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:40:03 -0500
Date: Wed, 3 Dec 2014 09:39:45 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] ARM: zynq: DT: Add USB to device tree
References: <1417536431-27759-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1417536431-27759-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21146.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(479174003)(199003)(51704005)(24454002)(377454003)(164054003)(189002)(108616004)(6806004)(102836001)(44976005)(33646002)(92566001)(31966008)(95666004)(77096005)(64706001)(77156002)(19580395003)(99396003)(50466002)(106466001)(65806001)(104016003)(19580405001)(83506001)(120916001)(21056001)(20776003)(46102003)(107046002)(64126003)(47776003)(87936001)(74316001)(65956001)(62966003)(86362001)(76176999)(4396001)(54356999)(50986999)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB053;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB053;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB053;
X-Forefront-PRVS: 0414DF926F
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB053;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 05:07 PM, Soren Brinkmann wrote:
> Add USB nodes to zc702, zc706 and zed device trees.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> v3:
>  - rename phy nodes: usb_phy -> phy0
>  - rebased onto zynq/dt
> v2:
>  - remove '@0' from phy node name
>  - don't add bogus space
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 20 ++++++++++++++++++++
>  arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
>  arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
>  arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
>  4 files changed, 51 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index f8e4a28adfc0..21aae01a3fe9 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -314,5 +314,25 @@
>  			reg = <0xf8f00600 0x20>;
>  			clocks = <&clkc 4>;
>  		};
> +
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
>  	};
>  };
> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
> index 280f02dd4ddc..399fed4d9c19 100644
> --- a/arch/arm/boot/dts/zynq-zc702.dts
> +++ b/arch/arm/boot/dts/zynq-zc702.dts
> @@ -36,6 +36,11 @@
>  			linux,default-trigger = "heartbeat";
>  		};
>  	};
> +
> +	usb_phy0: phy0 {
> +		compatible = "usb-nop-xceiv";
> +		#phy-cells = <0>;
> +	};
>  };
>  
>  &can0 {
> @@ -139,3 +144,9 @@
>  &uart1 {
>  	status = "okay";
>  };
> +
> +&usb0 {
> +	status = "okay";
> +	dr_mode = "host";
> +	usb-phy = <&usb_phy0>;
> +};
> diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
> index 34f7812d2ee8..89cc9adc569d 100644
> --- a/arch/arm/boot/dts/zynq-zc706.dts
> +++ b/arch/arm/boot/dts/zynq-zc706.dts
> @@ -27,6 +27,10 @@
>  		bootargs = "console=ttyPS0,115200 earlyprintk";
>  	};
>  
> +	usb_phy0: phy0 {
> +		compatible = "usb-nop-xceiv";
> +		#phy-cells = <0>;
> +	};
>  };
>  
>  &clkc {
> @@ -118,3 +122,9 @@
>  &uart1 {
>  	status = "okay";
>  };
> +
> +&usb0 {
> +	status = "okay";
> +	dr_mode = "host";
> +	usb-phy = <&usb_phy0>;
> +};
> diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
> index 1c7cc990b47a..e20956e5e720 100644
> --- a/arch/arm/boot/dts/zynq-zed.dts
> +++ b/arch/arm/boot/dts/zynq-zed.dts
> @@ -27,6 +27,10 @@
>  		bootargs = "console=ttyPS0,115200 earlyprintk";
>  	};
>  
> +	usb_phy0: phy0 {
> +		compatible = "usb-nop-xceiv";
> +		#phy-cells = <0>;
> +	};
>  };
>  
>  &clkc {
> @@ -50,3 +54,9 @@
>  &uart1 {
>  	status = "okay";
>  };
> +
> +&usb0 {
> +	status = "okay";
> +	dr_mode = "host";
> +	usb-phy = <&usb_phy0>;
> +};
> 

Applied to zynq/dt.

Thanks,
Michal

