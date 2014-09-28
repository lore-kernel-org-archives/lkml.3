Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854AbaI1EDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 00:03:13 -0400
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:21806
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750719AbaI1EDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 00:03:12 -0400
Date: Sun, 28 Sep 2014 12:02:34 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sanchayan Maity <maitysanchayan@gmail.com>
CC: <kernel@pengutronix.de>, <a.zummo@towertech.it>, <b35083@freescale.com>,
        <rtc-linux@googlegroups.com>, <stefan@agner.ch>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: dts: vf610: Add SNVS node
Message-ID: <20140928040233.GG12999@dragon>
References: <cover.1411736171.git.maitysanchayan@gmail.com>
 <49cb7f5fc8319fc47dc2919a2ccbff981196d4ff.1411736171.git.maitysanchayan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <49cb7f5fc8319fc47dc2919a2ccbff981196d4ff.1411736171.git.maitysanchayan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [221.225.208.47]
X-ClientProxiedBy: SINPR06CA004.apcprd06.prod.outlook.com (10.242.48.44) To
 DM2PR03MB349.namprd03.prod.outlook.com (10.141.54.11)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB349;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(24454002)(189002)(85306004)(50466002)(105586002)(110136001)(19580395003)(46102003)(97736003)(19580405001)(83322001)(81342003)(74502003)(95666004)(74662003)(90102001)(97756001)(77982003)(46406003)(81542003)(80022003)(77096002)(79102003)(83072002)(33716001)(85852003)(107046002)(4396001)(66066001)(92566001)(101416001)(1411001)(20776003)(47776003)(106356001)(92726001)(575784001)(64706001)(86362001)(21056001)(31966008)(102836001)(33656002)(83506001)(54356999)(76176999)(42186005)(99396003)(23726002)(87976001)(76482002)(120916001)(50986999)(10300001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB349;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 06:44:00PM +0530, Sanchayan Maity wrote:
> This adds a devicetree node for RTC support
> for the VF610 platform.
> 
> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> ---
>  arch/arm/boot/dts/vf610.dtsi |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 4d2ec32..3c0c757 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -381,6 +381,21 @@
>  					<&clks VF610_CLK_DMAMUX3>;
>  			};
>  
> +			snvs0: snvs@400a7000 {
> +				compatible = "fsl,sec-v4.0-mon", "simple-bus";
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				ranges = <0 0x400a7000 0x2000>;
> +
> +				snvs-rtc-lp@34 {
> +					compatible = "fsl,sec-v4.0-mon-rtc-lp";
> +					reg = <0x34 0x58>;
> +					interrupts = <0 100 IRQ_TYPE_LEVEL_HIGH>;
> +					clocks = <&clks VF610_CLK_SNVS>;
> +					clock-names = "snvs";

The name should describe the clock usage inside the block, so "snvs" is
not a good description.

Shawn

> +				};
> +			};
> +
>  			uart4: serial@400a9000 {
>  				compatible = "fsl,vf610-lpuart";
>  				reg = <0x400a9000 0x1000>;
> -- 
> 1.7.9.5
> 
