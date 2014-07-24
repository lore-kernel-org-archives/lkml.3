Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251AbaGXGpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:45:16 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:46159
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934076AbaGXGpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:45:13 -0400
Date: Thu, 24 Jul 2014 08:44:59 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
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
In-Reply-To: <20140723160702.GA14564@xsjandreislx>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
Message-ID: <2fe3a869-d17c-4521-a5c1-7c347ae34726@BN1BFFO11FD060.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(199002)(24454002)(479174003)(189002)(377454003)(164054003)(76104003)(51704005)(81542001)(64706001)(21056001)(95666004)(80022001)(4396001)(104016003)(83072002)(31966008)(20776003)(6806004)(92726001)(76176999)(65806001)(19580395003)(85306003)(33646002)(65956001)(44976005)(106466001)(50986999)(19580405001)(70736001)(77982001)(1496007)(87936001)(83322001)(64126003)(31696002)(74662001)(86362001)(76482001)(79102001)(99396002)(74502001)(85852003)(50466002)(23676002)(102836001)(92566001)(81342001)(83506001)(74316001)(47776003)(107046002)(54356999)(46102001)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB017;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 06:07 PM, Sören Brinkmann wrote:
> On Wed, 2014-07-23 at 03:05PM +0200, Michal Simek wrote:
>> Add node describing Zynq's CAN controller.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>>  arch/arm/boot/dts/zynq-7000.dtsi | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
>> index 366ca6434f54..2287d9b4ed1a 100644
>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>> @@ -71,7 +71,18 @@
>>  			interrupts = <0 7 4>;
>>  			interrupt-parent = <&intc>;
>>  			clocks = <&clkc 12>;
>> -		};
>> +		};
>> +
>> +		can0: can@e0008000 {
>> +			compatible = "xlnx,zynq-can-1.0";
>> +			clocks = <&clkc 19>, <&clkc 36>;
>> +			clock-names = "can_clk", "pclk";
>> +			reg = <0xe0008000 0x1000>;
>> +			interrupts = <0 28 4>;
>> +			interrupt-parent = <&intc>;
>> +			tx-fifo-depth = <0x40>;
>> +			rx-fifo-depth = <0x40>;
>> +		};
> 
> What about the second CAN core? You also probably want to add
> 'status = "disabled"' in the dtsi.

Second can core - yes.

I can add status = "disabled" but then question is if make
sense to change status for any zynq dts file. Or just
keep enable both.

In our repo is enabled can0 on zc702.

What do you think?

Thanks,
Michal

