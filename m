Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935351AbaGXX2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:28:33 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:4219
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934902AbaGXX23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:28:29 -0400
Date: Thu, 24 Jul 2014 16:28:16 -0700
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
Subject: Re: [PATCH v2 06/11] ARM: dts: zynq: Add DMAC for Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-7-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406242820-20140-7-git-send-email-afaerber@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <bc390439-9a5b-43a1-a70c-a4c6517a6cb6@BN1AFFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(189002)(24454002)(199002)(51704005)(70736001)(86362001)(53416004)(31966008)(50986999)(74662001)(83072002)(76482001)(81342001)(81542001)(4396001)(74502001)(106466001)(1496007)(83322001)(77982001)(77096002)(19580405001)(21056001)(95666004)(46102001)(44976005)(92566001)(107046002)(31696002)(85852003)(99396002)(110136001)(20776003)(74316001)(92726001)(54356999)(76176999)(87936001)(50466002)(33646002)(79102001)(104016003)(102836001)(19580395003)(6806004)(85306003)(83506001)(80022001)(85202003)(85182001)(23676002)(64706001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB031;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 01:00AM +0200, Andreas Färber wrote:
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v2: New
>  
>  arch/arm/boot/dts/zynq-7000.dtsi      | 17 +++++++++++++++++
>  arch/arm/boot/dts/zynq-parallella.dts |  4 ++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index eed3df0..1a70277 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -223,6 +223,23 @@
>  			};
>  		};
>  
> +		dmac_s: dmac@f8003000 {
> +			compatible = "arm,pl330", "arm,primecell";
> +			reg = <0xf8003000 0x1000>;
> +			status = "disabled";
I think for this IP we can omit the 'status' property since it is always
enabled. I don't see a reason to override it in each board DT.

> +			interrupt-parent = <&intc>;
> +			interrupts = <0 13 4>,
> +			             <0 14 4>, <0 15 4>,
> +			             <0 16 4>, <0 17 4>,
> +			             <0 40 4>, <0 41 4>,
> +			             <0 42 4>, <0 43 4>;
> +			#dma-cells = <1>;
> +			#dma-channels = <8>;
> +			#dma-requests = <4>;
> +			clocks = <&clkc 27>;
> +			clock-names = "apb_pclk";
> +		};
> +

Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Sören

