Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934972AbaGXXSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:18:40 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:14133
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934768AbaGXXSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:18:38 -0400
Date: Thu, 24 Jul 2014 16:18:29 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-6-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406242820-20140-6-git-send-email-afaerber@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ddb38ce5-9e31-4c94-967c-7784c7fba75c@BN1BFFO11FD028.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(24454002)(51704005)(199002)(189002)(83506001)(70736001)(44976005)(77982001)(46102001)(50466002)(6806004)(83072002)(81342001)(85202003)(85182001)(64706001)(74316001)(50986999)(107046002)(19580395003)(83322001)(19580405001)(92566001)(86362001)(31696002)(85852003)(79102001)(92726001)(104016003)(110136001)(106466001)(31966008)(33646002)(76482001)(74662001)(54356999)(4396001)(81542001)(1496007)(99396002)(76176999)(87936001)(77096002)(80022001)(21056001)(102836001)(53416004)(85306003)(20776003)(74502001)(23676002)(95666004)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB026;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 01:00AM +0200, Andreas Färber wrote:
> Prepare SPI0 and SPI1 while at it.
> 
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v2: New
>  
>  arch/arm/boot/dts/zynq-7000.dtsi      | 37 +++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/zynq-parallella.dts |  4 ++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 8fd826a..eed3df0 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -122,6 +122,30 @@
>  			interrupts = <0 50 4>;
>  		};
>  
> +		spi0: spi@e0006000 {
> +			compatible = "xlnx,zynq-spi-r1p6";
> +			reg = <0xe0006000 0x1000>;
> +			status = "disabled";
> +			interrupt-parent = <&intc>;
> +			interrupts = <0 26 4>;
> +			clocks = <&clkc 25>, <&clkc 34>;
> +			clock-names = "ref_clk", "pclk";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		spi1: spi@e0007000 {
> +			compatible = "xlnx,zynq-spi-r1p6";
> +			reg = <0xe0007000 0x1000>;
> +			status = "disabled";
> +			interrupt-parent = <&intc>;
> +			interrupts = <0 49 4>;
> +			clocks = <&clkc 26>, <&clkc 35>;
> +			clock-names = "ref_clk", "pclk";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
Until here things look good.

>  		gem0: ethernet@e000b000 {
>  			compatible = "cdns,gem";
>  			reg = <0xe000b000 0x4000>;
> @@ -140,6 +164,19 @@
>  			clock-names = "pclk", "hclk", "tx_clk";
>  		};
>  
> +		qspi: qspi@e000d000 {
> +			compatible = "xlnx,zynq-spi-r1p6";
> +			reg = <0xe000d000 0x1000>;
> +			status = "disabled";
> +			interrupt-parent = <&intc>;
> +			interrupts = <0 19 4>;
> +			clocks = <&clkc 10>, <&clkc 43>;
> +			clock-names = "ref_clk", "pclk";
> +			num-cs = <1>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
I'm not sure what the status of this driver is. I think QSPI is still
under review on the mailing lists and I don't think we should add this
yet.

	Sören

