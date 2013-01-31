Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3AaCzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 21:55:36 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:55780
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab3AaCze convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 21:55:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946hbe9i1155h)
From: Zhang Quan-B13634 <B13634@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] ARM: imx: set CKO1 parent clock source in imx6q
 sabresd
Thread-Topic: [PATCH 2/4] ARM: imx: set CKO1 parent clock source in imx6q
 sabresd
Thread-Index: AQHN/hPDc1QamsoVgkSK/QtRG8ymo5hiwDng
Date: Thu, 31 Jan 2013 02:55:28 +0000
Message-ID: <8D894AC610DA3944965280D4097EAC4603CCA73F@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1359445779-2038-1-git-send-email-b13634@freescale.com>
 <20130129112846.GG21504@S2101-09.ap.freescale.net>
In-Reply-To: <20130129112846.GG21504@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn,
Thank your feedback, please see the comments inline


Best Regards
Gary


>  -----Original Message-----
>  From: Shawn Guo [mailto:shawn.guo@linaro.org]
>  Sent: Tuesday, January 29, 2013 19:29
>  To: Zhang Quan-B13634
>  Cc: kernel@pengutronix.de; linux@arm.linux.org.uk; linux-kernel@vger.kernel.org
>  Subject: Re: [PATCH 2/4] ARM: imx: set CKO1 parent clock source in imx6q
>  sabresd
>  
>  Gary,
>  
>  For arch/arm/ patches, list linux-arm-kernel@lists.infradead.org rather than
>  linux-kernel@vger.kernel.org should be copied.
[Gary-b13634] agree

>  
>  One comment blow.
>  
>  On Tue, Jan 29, 2013 at 03:49:39PM +0800, Gary Zhang wrote:
>  > in imx6q sabresd board, wm8962 uses CKO1 as MCLK. set ahb as CKO1
>  > parent clock source
>  >
>  > Signed-off-by: Gary Zhang <b13634@freescale.com>
>  > ---
>  >  arch/arm/mach-imx/mach-imx6q.c |   32 ++++++++++++++++++++++++++++++++
>  >  1 files changed, 32 insertions(+), 0 deletions(-)
>  >
>  > diff --git a/arch/arm/mach-imx/mach-imx6q.c
>  > b/arch/arm/mach-imx/mach-imx6q.c index 4eb1b3a..ee3f357 100644
>  > --- a/arch/arm/mach-imx/mach-imx6q.c
>  > +++ b/arch/arm/mach-imx/mach-imx6q.c
>  > @@ -151,6 +151,36 @@ static void __init imx6q_sabrelite_init(void)
>  >  	imx6q_sabrelite_cko1_setup();
>  >  }
>  >
>  > +static void __init imx6q_sabresd_cko1_setup(void) {
>  > +	struct clk *cko1_sel, *ahb, *cko1;
>  > +	unsigned long rate;
>  > +
>  > +	cko1_sel = clk_get_sys(NULL, "cko1_sel");
>  > +	ahb = clk_get_sys(NULL, "ahb");
>  > +	cko1 = clk_get_sys(NULL, "cko1");
>  > +	if (IS_ERR(cko1_sel) || IS_ERR(ahb) || IS_ERR(cko1)) {
>  > +		pr_err("cko1 setup failed!\n");
>  > +		goto put_clk;
>  > +	}
>  > +	clk_set_parent(cko1_sel, ahb);
>  > +	rate = clk_round_rate(cko1, 24000000);
>  > +	clk_set_rate(cko1, rate);
>  > +
>  > +	return;
>  > +put_clk:
>  > +	if (!IS_ERR(cko1_sel))
>  > +		clk_put(cko1_sel);
>  > +	if (!IS_ERR(ahb))
>  > +		clk_put(ahb);
>  > +	if (!IS_ERR(cko1))
>  > +		clk_put(cko1);
>  > +}
>  
>  So the only difference between this function and imx6q_sabrelite_cko1_setup()
>  is the frequency set on cko1?  If so, we should consolidate them with frequency
>  passed in as a parameter.
[Gary-b13634] OK, I	 will do it.

>  
>  Shawn
>  
>  > +static void __init imx6q_sabresd_init(void) {
>  > +	imx6q_sabresd_cko1_setup();
>  > +}
>  > +
>  >  static void __init imx6q_1588_init(void)  {
>  >  	struct regmap *gpr;
>  > @@ -193,6 +223,8 @@ static void __init imx6q_init_machine(void)  {
>  >  	if (of_machine_is_compatible("fsl,imx6q-sabrelite"))
>  >  		imx6q_sabrelite_init();
>  > +	else if (of_machine_is_compatible("fsl,imx6q-sabresd"))
>  > +		imx6q_sabresd_init();
>  >
>  >  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>  >
>  > --
>  > 1.7.0.4
>  >
>  >

