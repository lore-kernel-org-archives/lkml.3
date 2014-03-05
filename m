Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaCER7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:59:47 -0500
Received: from mail-by2on0144.outbound.protection.outlook.com ([207.46.100.144]:51479
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850AbaCER7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:59:46 -0500
X-Greylist: delayed 5605 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 12:59:45 EST
Message-ID: <1394036628.23289.0.camel@linux-builds1>
Subject: Re: [PATCH] dts: add support for MMC on socfpga boards
From: Dinh Nguyen <dinguyen@altera.com>
To: ZY - pavel <pavel@denx.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>
Date: Wed, 5 Mar 2014 10:23:48 -0600
In-Reply-To: <20140305162350.GA3674@pollux.denx.de>
References: <20140305162350.GA3674@pollux.denx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(448001)(164054003)(51704005)(377424004)(24454002)(199002)(189002)(54316002)(87266001)(87286001)(79102001)(6806004)(74706001)(95666003)(47446002)(74502001)(31966008)(56816005)(89996001)(90146001)(69226001)(65816001)(80022001)(77156001)(62966002)(80976001)(23676002)(95416001)(44976005)(19580405001)(83322001)(59766001)(19580395003)(77982001)(81686001)(74876001)(85326001)(81816001)(20776003)(63696002)(47776003)(87936001)(85306002)(86362001)(93516002)(74366001)(46102001)(93136001)(4396001)(47976001)(92566001)(76482001)(92726001)(51856001)(50986001)(50226001)(47736001)(49866001)(94946001)(33716001)(33646001)(53806001)(94316002)(81342001)(77096001)(85852003)(83072002)(76796001)(76786001)(81542001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1BFFO11HUB050;H:SJ-ITEXEDGE02.altera.priv.altera.com;CLIP:66.35.236.232;FPR:F2E47562.3CD09CB7.9BE69026.1B866ED2.20175;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 01415BB535
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 17:23 +0100, ZY - pavel wrote:
> Add DTS binding for MMC on socfpga boards. Tested on Sockit.
>     
> Signed-off-by: Pavel Machek <pavel@denx.de>
> 
> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 537f1a5..cad7526 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -521,6 +521,23 @@
>  			reg-io-width = <4>;
>  		};
>  
> +		mmc: dwmmc0@ff704000 {
> +			compatible = "snps,dw-mshc";
> +			reg = <0xff704000 0x1000>;
> +			interrupts = <0 139 4>;
> +			clock-frequency = <12500000>; /*12.5 MHz*/
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			num-slots = <1>;
> +			supports-highspeed;
> +			broken-cd;
> +			fifo-depth = <0x400>;
> +			slot@0 {
> +				reg = <0>;
> +				bus-width = <4>;
> +			};
> +		};
> +
>  		rstmgr@ffd05000 {
>  			compatible = "altr,rst-mgr";
>  			reg = <0xffd05000 0x1000>;
> 

This is already queued in Chris Ball's MMC tree.

Thanks,
Dinh


