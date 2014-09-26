Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaIZBmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:42:08 -0400
Received: from mail-by2on0136.outbound.protection.outlook.com ([207.46.100.136]:50890
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752854AbaIZBmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:42:06 -0400
Date: Fri, 26 Sep 2014 09:41:27 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <daniel.lezcano@linaro.org>, <tglx@linutronix.de>,
        <festevam@gmail.com>, <jingchang.lu@freescale.com>,
        <bpringlemeir@nbsps.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: dts: vf610: Add ARM Global Timer
Message-ID: <20140926014126.GE21077@dragon>
References: <1411575610-20895-1-git-send-email-stefan@agner.ch>
 <1411575610-20895-3-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411575610-20895-3-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(189002)(24454002)(199003)(33716001)(44976005)(68736004)(33656002)(50986999)(83072002)(76482002)(23726002)(50466002)(97756001)(81342003)(83506001)(120916001)(64706001)(19580395003)(31966008)(6806004)(83322001)(92726001)(46406003)(76176999)(84676001)(86362001)(99396003)(10300001)(47776003)(69596002)(92566001)(81542003)(21056001)(19580405001)(4396001)(54356999)(102836001)(57986006)(79102003)(46102003)(74662003)(77982003)(107046002)(80022003)(90102001)(97736003)(85852003)(81156004)(110136001)(87936001)(74502003)(20776003)(105606002)(85306004)(104016003)(95666004)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB469;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB469;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 06:20:09PM +0200, Stefan Agner wrote:
> Add Global Timer support which is part of the private peripherals
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
> index 4d2ec32..3232b9a 100644
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
> +			timer: global-timer@40002200 {

The renaming to "timer" should be applied on node name, not the label
name.  I change it as below and applied the patch.

	global_timer: timer@40002200

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
