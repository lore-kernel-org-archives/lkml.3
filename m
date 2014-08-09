Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaHIN6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 09:58:55 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:16813
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751065AbaHIN6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 09:58:54 -0400
Date: Sat, 9 Aug 2014 21:58:42 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <Guangyu.Chen@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 3/3] ARM: clk-imx6q: Add missing lvds and anaclk clock
 to the clock tree
Message-ID: <20140809135841.GB8849@dragon>
References: <cover.1407481023.git.shengjiu.wang@freescale.com>
 <9ecf6480464cffb3b4347ad3fd8ec5f07462a0fc.1407481023.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9ecf6480464cffb3b4347ad3fd8ec5f07462a0fc.1407481023.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(51704005)(24454002)(46102001)(80022001)(64706001)(83322001)(44976005)(50466002)(6806004)(33656002)(47776003)(74662001)(106466001)(31966008)(105606002)(110136001)(20776003)(92566001)(21056001)(74502001)(107046002)(86362001)(83072002)(84676001)(85852003)(92726001)(33716001)(102836001)(26826002)(85306004)(104016003)(95666004)(57986006)(81542001)(76482001)(77982001)(4396001)(68736004)(99396002)(83506001)(87936001)(50986999)(79102001)(54356999)(97736001)(97756001)(46406003)(23726002)(81342001)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB328;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02981BE340
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 03:02:49PM +0800, Shengjiu Wang wrote:
> @@ -176,8 +182,12 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	 * the "output_enable" bit as a gate, even though it's really just
>  	 * enabling clock output.
>  	 */
> -	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> -	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> +	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate2("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> +	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate2("lvds2_gate", "lvds2_sel", base + 0x160, 11);

I do not think you can simply change to use imx_clk_gate2() here.  It's
designed for those CCGR gate clocks, each of which is controlled by two
bits.

Shawn

> +	clk[IMX6QDL_CLK_LVDS1_IN] = imx_clk_gate2("lvds1_in", "anaclk1", base + 0x160, 12);
> +	clk[IMX6QDL_CLK_LVDS2_IN] = imx_clk_gate2("lvds2_in", "anaclk2", base + 0x160, 13);
> +	imx_clk_gate2_exclusive(clk[IMX6QDL_CLK_LVDS1_GATE], clk[IMX6QDL_CLK_LVDS1_IN]);
> +	imx_clk_gate2_exclusive(clk[IMX6QDL_CLK_LVDS2_GATE], clk[IMX6QDL_CLK_LVDS2_IN]);
>  
>  	/*                                            name              parent_name        reg       idx */
>  	clk[IMX6QDL_CLK_PLL2_PFD0_352M] = imx_clk_pfd("pll2_pfd0_352m", "pll2_bus",     base + 0x100, 0);
