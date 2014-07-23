Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbaGWQLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:11:31 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:30904
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754176AbaGWQL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:11:29 -0400
Date: Wed, 23 Jul 2014 09:07:02 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <monstr@monstr.eu>,
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
Subject: Re: [PATCH] ARM: zynq: DT: Add CAN node
References: <52d799e17cd3539713625c6f6a6666620f52d692.1406120732.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52d799e17cd3539713625c6f6a6666620f52d692.1406120732.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-ID: <0a68731a-e0f0-4e19-b9a4-57cec4c8de3b@BN1BFFO11FD048.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(24454002)(377424004)(199002)(189002)(74662001)(77982001)(80022001)(64706001)(74316001)(31696002)(76482001)(79102001)(53416004)(107046002)(4396001)(81342001)(20776003)(85202003)(106466001)(95666004)(21056001)(81542001)(83506001)(70736001)(46102001)(74502001)(102836001)(76176999)(19580395003)(92566001)(54356999)(99396002)(50986999)(85182001)(104016003)(77096002)(50466002)(92726001)(31966008)(33646002)(47776003)(86362001)(44976005)(23676002)(85852003)(83322001)(87936001)(110136001)(6806004)(1496007)(85306003)(83072002)(19580405001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB039;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 03:05PM +0200, Michal Simek wrote:
> Add node describing Zynq's CAN controller.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
>  arch/arm/boot/dts/zynq-7000.dtsi | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 366ca6434f54..2287d9b4ed1a 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -71,7 +71,18 @@
>  			interrupts = <0 7 4>;
>  			interrupt-parent = <&intc>;
>  			clocks = <&clkc 12>;
> -		};
> +		};
> +
> +		can0: can@e0008000 {
> +			compatible = "xlnx,zynq-can-1.0";
> +			clocks = <&clkc 19>, <&clkc 36>;
> +			clock-names = "can_clk", "pclk";
> +			reg = <0xe0008000 0x1000>;
> +			interrupts = <0 28 4>;
> +			interrupt-parent = <&intc>;
> +			tx-fifo-depth = <0x40>;
> +			rx-fifo-depth = <0x40>;
> +		};

What about the second CAN core? You also probably want to add
'status = "disabled"' in the dtsi.

	Sören

