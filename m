Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaLAIKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:10:40 -0500
Received: from mail-bn1bon0063.outbound.protection.outlook.com ([157.56.111.63]:42880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752390AbaLAIKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:10:38 -0500
Date: Mon, 1 Dec 2014 09:10:23 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Crosthwaite <crosthwaitepeter@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <sorenb@xilinx.com>, <steven.wang@digilentinc.com>
Subject: Re: [PATCH v3 3/3] arm: dts: zynq: Add Digilent ZYBO board
References: <1417393550-6674-1-git-send-email-crosthwaite.peter@gmail.com>
 <1417393550-6674-3-git-send-email-crosthwaite.peter@gmail.com>
In-Reply-To: <1417393550-6674-3-git-send-email-crosthwaite.peter@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21142.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <060b3df0d8ac4b20862fd4282a52e7f7@BY2FFO11FD034.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(199003)(189002)(51704005)(164054003)(479174003)(377454003)(74316001)(21056001)(102836001)(19580395003)(31966008)(77156002)(50986999)(87936001)(4396001)(65806001)(54356999)(65956001)(23746002)(6806004)(2201001)(86362001)(62966003)(19580405001)(107046002)(64706001)(20776003)(47776003)(92566001)(99396003)(50466002)(76176999)(83506001)(104016003)(108616004)(95666004)(46102003)(44976005)(120916001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB012;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB012;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB012;
X-Forefront-PRVS: 0412A98A59
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB012;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 01:25 AM, Peter Crosthwaite wrote:
> Add a DTS describing the Digilent ZYBO board. Similar to ZED but with
> a 50MHz crystal instead of 33MHz.
> 
> Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Signed-off-by: Peter Crosthwaite <crosthwaite.peter@gmail.com>
> 
> ---
> Changed since v1:
> Change compat vendor prefix from xlnx to digilent (Soren review)
> Alphabetise nodes
> ---
>  arch/arm/boot/dts/Makefile      |  3 ++-
>  arch/arm/boot/dts/zynq-zybo.dts | 52 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/zynq-zybo.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 7cd36a7..be2e8ce 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -513,7 +513,8 @@ dtb-$(CONFIG_ARCH_ZYNQ) += \
>  	zynq-parallella.dtb \
>  	zynq-zc702.dtb \
>  	zynq-zc706.dtb \
> -	zynq-zed.dtb
> +	zynq-zed.dtb \
> +	zynq-zybo.dtb
>  dtb-$(CONFIG_MACH_ARMADA_370) += \
>  	armada-370-db.dtb \
>  	armada-370-mirabox.dtb \
> diff --git a/arch/arm/boot/dts/zynq-zybo.dts b/arch/arm/boot/dts/zynq-zybo.dts
> new file mode 100644
> index 0000000..a9a12ce
> --- /dev/null
> +++ b/arch/arm/boot/dts/zynq-zybo.dts
> @@ -0,0 +1,52 @@
> +/*
> + *  Copyright (C) 2011 - 2014 Xilinx
> + *  Copyright (C) 2012 National Instruments Corp.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +/dts-v1/;
> +/include/ "zynq-7000.dtsi"
> +
> +/ {
> +	model = "Zynq ZYBO Development Board";
> +	compatible = "digilent,zynq-zybo", "xlnx,zynq-7000";
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x0 0x20000000>;
> +	};
> +
> +	chosen {
> +		bootargs = "console=ttyPS0,115200 earlyprintk";
> +	};
> +
> +};
> +
> +&clkc {
> +	ps-clk-frequency = <50000000>;
> +};
> +
> +&gem0 {
> +	status = "okay";
> +	phy-mode = "rgmii-id";
> +	phy-handle = <&ethernet_phy>;
> +
> +	ethernet_phy: ethernet-phy@0 {
> +		reg = <0>;
> +	};
> +};
> +
> +&sdhci0 {
> +	status = "okay";
> +};
> +
> +&uart1 {
> +	status = "okay";
> +};
> 

Applied all to zynq/dt branch.

Thanks,
Michal

