Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaIYHvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:51:24 -0400
Received: from mail-bn1bn0108.outbound.protection.outlook.com ([157.56.110.108]:35452
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752586AbaIYHvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:51:20 -0400
Date: Thu, 25 Sep 2014 15:50:15 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <festevam@gmail.com>,
        <jingchang.lu@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: vf610: Use ARM Global Timer as clocksource
Message-ID: <20140925075013.GD6405@dragon>
References: <1410437175-6636-1-git-send-email-stefan@agner.ch>
 <1410437175-6636-2-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410437175-6636-2-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [180.108.234.93]
X-ClientProxiedBy: HKXPR01CA007.apcprd01.prod.exchangelabs.com (10.242.96.17)
 To BLUPR03MB342.namprd03.prod.outlook.com (10.141.48.13)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB342;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(51704005)(199003)(83506001)(120916001)(106356001)(107046002)(10300001)(19580405001)(46406003)(19580395003)(66066001)(97756001)(85852003)(83322001)(42186005)(83072002)(81542003)(31966008)(47776003)(20776003)(46102003)(77982003)(80022003)(90102001)(85306004)(74662003)(64706001)(74502003)(79102003)(81342003)(21056001)(95666004)(33656002)(86362001)(97736003)(102836001)(110136001)(99396003)(87976001)(92566001)(92726001)(23726002)(4396001)(33716001)(50466002)(105586002)(101416001)(76482002)(76176999)(50986999)(54356999)(77096002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB342;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 02:06:15PM +0200, Stefan Agner wrote:
> Use ARM Global Timer as clocksource instead of the PIT timer. This
> leaves the PIT timer for other users e.g. the secondary Cortex-M4
> core. Also, the Global Timer has double the precission (running at
> pheripheral clock compared to IPG clock) and a 64-bit incrementing
> counter register.

I just think of one thing.  Will this change cause a problem of the low
power idle support in case we want to power down ARM core in there?

Shawn

> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> Theoretically we could remove the PIT driver now. But we could also
> enable both drivers, but is having two clock source useful for the
> Kernel at all?
> 
>  arch/arm/mach-imx/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 64161aa..adc77180 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -656,7 +656,8 @@ config SOC_VF610
>  	bool "Vybrid Family VF610 support"
>  	select ARM_GIC
>  	select PINCTRL_VF610
> -	select VF_PIT_TIMER
> +	select ARM_GLOBAL_TIMER
> +	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>  	select PL310_ERRATA_769419 if CACHE_L2X0
>  
>  	help
> -- 
> 2.1.0
> 
