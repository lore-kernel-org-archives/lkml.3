Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbaGXPzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:55:40 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:32103
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759405AbaGXPzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:55:36 -0400
Date: Thu, 24 Jul 2014 08:55:21 -0700
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
 <20140723160702.GA14564@xsjandreislx>
 <2fe3a869-d17c-4521-a5c1-7c347ae34726@BN1BFFO11FD060.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2fe3a869-d17c-4521-a5c1-7c347ae34726@BN1BFFO11FD060.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <d973d7c8-30e7-458e-9d57-15da917cde04@BL2FFO11FD030.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(377454003)(189002)(51704005)(76104003)(199002)(24454002)(479174003)(83322001)(70736001)(86362001)(92566001)(79102001)(44976005)(47776003)(85852003)(106466001)(31696002)(80022001)(46102001)(92726001)(74502001)(77982001)(19580405001)(4396001)(81542001)(19580395003)(1496007)(83506001)(99396002)(76482001)(95666004)(74316001)(77096002)(76176999)(6806004)(85306003)(50986999)(107046002)(110136001)(31966008)(83072002)(20776003)(102836001)(64706001)(104016003)(87936001)(81342001)(21056001)(50466002)(23676002)(54356999)(85182001)(74662001)(85202003)(53416004)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB053;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-24 at 08:44AM +0200, Michal Simek wrote:
> On 07/23/2014 06:07 PM, Sören Brinkmann wrote:
> > On Wed, 2014-07-23 at 03:05PM +0200, Michal Simek wrote:
> >> Add node describing Zynq's CAN controller.
> >>
> >> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> >> ---
> >>
> >>  arch/arm/boot/dts/zynq-7000.dtsi | 13 ++++++++++++-
> >>  1 file changed, 12 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> >> index 366ca6434f54..2287d9b4ed1a 100644
> >> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> >> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> >> @@ -71,7 +71,18 @@
> >>  			interrupts = <0 7 4>;
> >>  			interrupt-parent = <&intc>;
> >>  			clocks = <&clkc 12>;
> >> -		};
> >> +		};
> >> +
> >> +		can0: can@e0008000 {
> >> +			compatible = "xlnx,zynq-can-1.0";
> >> +			clocks = <&clkc 19>, <&clkc 36>;
> >> +			clock-names = "can_clk", "pclk";
> >> +			reg = <0xe0008000 0x1000>;
> >> +			interrupts = <0 28 4>;
> >> +			interrupt-parent = <&intc>;
> >> +			tx-fifo-depth = <0x40>;
> >> +			rx-fifo-depth = <0x40>;
> >> +		};
> > 
> > What about the second CAN core? You also probably want to add
> > 'status = "disabled"' in the dtsi.
> 
> Second can core - yes.
> 
> I can add status = "disabled" but then question is if make
> sense to change status for any zynq dts file. Or just
> keep enable both.
> 
> In our repo is enabled can0 on zc702.
> 
> What do you think?

Well, it should be enabled on boards that have CAN pinned out. Does any
of our boards have that?

	Sören

