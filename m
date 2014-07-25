Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbaGYPAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:00:37 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:37628
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753914AbaGYPAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:00:31 -0400
Date: Fri, 25 Jul 2014 08:00:17 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>, <monstr@monstr.eu>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: zynq: DT: Add CAN node
References: <56bf20294d106e0fc9c23a70cd991a50b441d0aa.1406271138.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56bf20294d106e0fc9c23a70cd991a50b441d0aa.1406271138.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <bed4104c-c177-4c6d-bffe-3535b9c0d354@BN1AFFO11FD029.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(199002)(189002)(51704005)(6806004)(31966008)(85306003)(87936001)(104016003)(107046002)(76482001)(21056001)(50466002)(64706001)(33646002)(83506001)(31696002)(83322001)(47776003)(4396001)(74316001)(85182001)(85202003)(70736001)(92566001)(99396002)(19580395003)(76176999)(46102001)(86362001)(92726001)(106466001)(79102001)(50986999)(54356999)(77982001)(83072002)(44976005)(80022001)(1496007)(74502001)(20776003)(81542001)(74662001)(95666004)(102836001)(53416004)(110136001)(19580405001)(85852003)(23676002)(77096002)(81342001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB065;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 08:52AM +0200, Michal Simek wrote:
> Add node describing Zynq's CAN controller.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
> Changes in v2:
> - Add can1
> - Enable can0 for zc702
> - Use status property
> 
>  arch/arm/boot/dts/zynq-7000.dtsi | 26 +++++++++++++++++++++++++-
>  arch/arm/boot/dts/zynq-zc702.dts |  4 ++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 366ca6434f54..983148111e3a 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -71,7 +71,31 @@
>  			interrupts = <0 7 4>;
>  			interrupt-parent = <&intc>;
>  			clocks = <&clkc 12>;
> -		};
> +		};
> +
> +		can0: can@e0008000 {
> +			compatible = "xlnx,zynq-can-1.0";
> +			status = "disabled";
> +			clocks = <&clkc 19>, <&clkc 36>;
> +			clock-names = "can_clk", "pclk";
> +			reg = <0xe0008000 0x1000>;
> +			interrupts = <0 28 4>;
> +			interrupt-parent = <&intc>;
> +			tx-fifo-depth = <0x40>;
> +			rx-fifo-depth = <0x40>;
> +		};
> +
> +		can1: can@e0009000 {
> +			compatible = "xlnx,zynq-can-1.0";
> +			status = "disabled";
> +			clocks = <&clkc 19>, <&clkc 36>;
The clocks for CAN1 must be outputs 20 and 37 of the clkc.

	Sören

