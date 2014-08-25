Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaHYHka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:40:30 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:33722
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753549AbaHYHk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:40:29 -0400
Date: Mon, 25 Aug 2014 15:40:20 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 3/3] ARM: clk-imx6q: Add missing lvds and anaclk clock
 to the clock tree
Message-ID: <20140825073957.GA7740@audiosh1>
References: <cover.1407481023.git.shengjiu.wang@freescale.com>
 <9ecf6480464cffb3b4347ad3fd8ec5f07462a0fc.1407481023.git.shengjiu.wang@freescale.com>
 <20140809135841.GB8849@dragon> <20140811030935.GB13158@audiosh1>
 <20140818060521.GA2114@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140818060521.GA2114@dragon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(51704005)(35774003)(24454002)(189002)(93886004)(81156004)(4396001)(85306004)(68736004)(80022001)(104016003)(81342001)(64706001)(54356999)(90102001)(26826002)(20776003)(84676001)(44976005)(92566001)(77982001)(85852003)(92726001)(21056001)(79102001)(69596002)(47776003)(99396002)(81542001)(6806004)(74502001)(83322001)(31966008)(74662001)(46102001)(50986999)(33716001)(33656002)(97736001)(46406003)(107046002)(102836001)(83072002)(97756001)(105606002)(106466001)(95666004)(76482001)(86362001)(83506001)(76176999)(23726002)(50466002)(110136001)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB346;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03142412E2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 02:06:07PM +0800, Shawn Guo wrote:
> On Mon, Aug 11, 2014 at 11:09:36AM +0800, Shengjiu Wang wrote:
> > On Sat, Aug 09, 2014 at 09:58:42PM +0800, Shawn Guo wrote:
> > > On Fri, Aug 08, 2014 at 03:02:49PM +0800, Shengjiu Wang wrote:
> > > > @@ -176,8 +182,12 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
> > > >  	 * the "output_enable" bit as a gate, even though it's really just
> > > >  	 * enabling clock output.
> > > >  	 */
> > > > -	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> > > > -	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> > > > +	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate2("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> > > > +	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate2("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> > > 
> > > I do not think you can simply change to use imx_clk_gate2() here.  It's
> > > designed for those CCGR gate clocks, each of which is controlled by two
> > > bits.
> > > 
> > > Shawn
> > >
> > As Lucas Stach's suggestion, we need to do add some method for mutually exclusive clock, 
> > lvds1_gate with lvds1_in, lvds2_gate with lvds2_in. I add imx_clk_gate2_exclusive() function in clk-gate2.c.
> > So I change imx_clk_gate() to imx_clk_gate2() here.
> > As you said, this is not good solution.
> 
> It's not just a "not good" solution but wrong and broken one.  The net
> result of that is if you call clk_enable() on lvds1_gate, both bit 10
> and 11 will be set.
> 
> > So I need your suggestion, how can I do?
> 
> I guess we will need a new clock type to handle such mutually exclusive
> clocks, rather than patching clk-gate2.
> 
Could you please help to implement this feature?

Furthermore, I'd like to drop patch 2 and patch 3, wait the implementation from
you.

Could you please review the patch 1?  do you have any comments?

Wang Shengjiu

> > First, is it allowable that to add imx_clk_gate2_exclusive() function, is there a more better way?
> 
> Again, this is completely wrong.
> 
> > second, or should I change the clk-gate.c to add exclusive control?
> 
> If such mutually exclusive clocks are somehow common across different
> clock controllers, we can propose to change clk-gate.c for handling
> them.  But I'm not sure this is a common case.
> 
> Shawn
