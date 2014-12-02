Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaLBJks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:40:48 -0500
Received: from mail-bn1on0081.outbound.protection.outlook.com ([157.56.110.81]:1451
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751362AbaLBJkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:40:45 -0500
Date: Tue, 2 Dec 2014 10:40:28 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH v2] ARM: zynq: DT: Add USB to device tree
References: <1417509978-19060-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1417509978-19060-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21144.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <63f1ea2ffb3f49f29ec46183f3009817@BN1AFFO11FD032.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(51704005)(479174003)(377454003)(199003)(189002)(24454002)(20776003)(47776003)(62966003)(54356999)(21056001)(19580395003)(19580405001)(46102003)(77156002)(6806004)(44976005)(23746002)(50986999)(107046002)(86362001)(106466001)(102836001)(83506001)(33646002)(76176999)(65956001)(64126003)(87936001)(4396001)(95666004)(50466002)(31966008)(99396003)(74316001)(120916001)(92566001)(104016003)(108616004)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB015;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB015;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB015;
X-Forefront-PRVS: 0413C9F1ED
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB015;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 09:46 AM, Soren Brinkmann wrote:
> Add USB nodes to zc702, zc706 and zed device trees.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
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
> index ce2ef5bec4f2..68096bb027db 100644
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
> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
> index 94e2cda6f9b6..f80c6e65f6e8 100644
> --- a/arch/arm/boot/dts/zynq-zc702.dts
> +++ b/arch/arm/boot/dts/zynq-zc702.dts
> @@ -36,6 +36,11 @@
>  			linux,default-trigger = "heartbeat";
>  		};
>  	};
> +
> +	usb_phy0: usb-phy {
> +		compatible = "usb-nop-xceiv";
> +		#phy-cells = <0>;
> +	};
>  };
>  
>  &can0 {
> @@ -135,3 +140,9 @@
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
> index a8bbdfbc7093..bece52e47cfe 100644
> --- a/arch/arm/boot/dts/zynq-zc706.dts
> +++ b/arch/arm/boot/dts/zynq-zc706.dts
> @@ -27,6 +27,10 @@
>  		bootargs = "console=ttyPS0,115200 earlyprintk";
>  	};
>  
> +	usb_phy0: usb-phy {
> +		compatible = "usb-nop-xceiv";
> +		#phy-cells = <0>;
> +	};
>  };
>  
>  &gem0 {
> @@ -114,3 +118,9 @@
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
> index 697779a353ed..efecb2379832 100644
> --- a/arch/arm/boot/dts/zynq-zed.dts
> +++ b/arch/arm/boot/dts/zynq-zed.dts
> @@ -27,6 +27,10 @@
>  		bootargs = "console=ttyPS0,115200 earlyprintk";
>  	};
>  
> +	usb_phy0: usb-phy {
> +		compatible = "usb-nop-xceiv";
> +		#phy-cells = <0>;
> +	};
>  };
>  
>  &gem0 {
> @@ -46,3 +50,9 @@
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

Based on Arnd comment please fix it and rebase it on the top of zynq/dt branch.

Thanks,
Michal

