Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaJUFyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:54:38 -0400
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:4766
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753255AbaJUFyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:54:37 -0400
Date: Tue, 21 Oct 2014 07:54:20 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH RFC v2 8/8] ARM: zynq: DT: Add pinctrl information
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
 <1413479495-14206-9-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1413479495-14206-9-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21040.002
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <ab4a1ef9a5f24e9e804dc27f6f1cea36@BN1AFFO11FD007.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(164054003)(479174003)(377454003)(24454002)(51704005)(189002)(23746002)(54356999)(106466001)(50986999)(76482002)(76176999)(95666004)(80022003)(46102003)(31966008)(102836001)(44976005)(21056001)(20776003)(65956001)(64706001)(19580405001)(47776003)(19580395003)(4396001)(50466002)(99396003)(120916001)(83506001)(92566001)(85852003)(86362001)(87936001)(33646002)(74316001)(6806004)(85306004)(107046002)(108616004)(64126003)(65826006)(107986001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB008;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB008;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 07:11 PM, Soren Brinkmann wrote:
> Add pinctrl descriptions to the zc702 and zc706 device trees.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi |   8 ++-
>  arch/arm/boot/dts/zynq-zc702.dts | 147 +++++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/zynq-zc706.dts | 126 +++++++++++++++++++++++++++++++++
>  3 files changed, 280 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 24036c440440..37d7fe36a129 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -238,7 +238,7 @@
>  		slcr: slcr@f8000000 {
>  			#address-cells = <1>;
>  			#size-cells = <1>;
> -			compatible = "xlnx,zynq-slcr", "syscon";
> +			compatible = "xlnx,zynq-slcr", "syscon", "simple-bus";

I expect that you have this here to be able to probe the driver.
slcr is not the bus.
You should be able just to probe child nodes.

Thanks,
Michal
