Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaILIOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:14:49 -0400
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:30776
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751185AbaILIOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:14:47 -0400
Date: Fri, 12 Sep 2014 15:59:01 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <festevam@gmail.com>,
        <jingchang.lu@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dts: vf610: Add ARM Global Timer
Message-ID: <20140912075900.GK18566@dragon>
References: <1410437175-6636-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410437175-6636-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(51704005)(24454002)(199003)(189002)(105606002)(85306004)(102836001)(84676001)(26826002)(97736003)(97756001)(33656002)(90102001)(106466001)(110136001)(104016003)(99396002)(46406003)(107046002)(46102001)(31966008)(77982001)(76176999)(83322001)(86362001)(54356999)(50986999)(81342001)(19580405001)(21056001)(79102001)(81542001)(4396001)(76482001)(6806004)(64706001)(68736004)(92726001)(20776003)(50466002)(92566001)(80022001)(47776003)(57986006)(95666004)(23726002)(83072002)(85852003)(74502001)(44976005)(87936001)(33716001)(74662001)(19580395003)(83506001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB465;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 02:06:14PM +0200, Stefan Agner wrote:
> Add Global Timer support which is part of the Snoop Control Unit
> of the Cortex-A5 processor. This Global Timer is compatible with the
> Cortex-A9 implementation. It's a 64-bit timer and is clocked by the
> peripheral clock, which is typically 133 or 166MHz on Vybrid.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/boot/dts/vf610.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 4d2ec32..a03abf6 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -11,6 +11,7 @@
>  #include "vf610-pinfunc.h"
>  #include <dt-bindings/clock/vf610-clock.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>  
>  / {
>  	aliases {
> @@ -83,6 +84,13 @@
>  				      <0x40002100 0x100>;
>  			};
>  
> +			global_timer: global-timer@40002200 {

I think it's more idiomatic to use the generic name 'timer' for the
node.

Shawn

> +				compatible = "arm,cortex-a9-global-timer";
> +				reg = <0x40002200 0x20>;
> +				interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks VF610_CLK_PLATFORM_BUS>;
> +			};
> +
>  			L2: l2-cache@40006000 {
>  				compatible = "arm,pl310-cache";
>  				reg = <0x40006000 0x1000>;
> -- 
> 2.1.0
> 
