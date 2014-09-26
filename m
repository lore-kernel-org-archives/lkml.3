Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaIZB5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:57:45 -0400
Received: from mail-bl2on0138.outbound.protection.outlook.com ([65.55.169.138]:44338
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752672AbaIZB5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:57:43 -0400
Date: Fri, 26 Sep 2014 09:57:14 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Xiubo Li-B47053 <Li.Xiubo@freescale.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] ARM: ls1021a: add gating clocks to IP blocks.
Message-ID: <20140926015713.GG21077@dragon>
References: <1411476275-9164-1-git-send-email-Li.Xiubo@freescale.com>
 <20140925085403.GG6405@dragon>
 <e44a1930e8de43ec8beb6e60fa9c1e9e@BY2PR0301MB0613.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e44a1930e8de43ec8beb6e60fa9c1e9e@BY2PR0301MB0613.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(189002)(199003)(102836001)(50466002)(33716001)(31966008)(81156004)(99396003)(106466001)(120916001)(57986006)(10300001)(21056001)(86362001)(95666004)(4396001)(105606002)(97736003)(90102001)(92566001)(81342003)(80022003)(74662003)(77982003)(79102003)(74502003)(46102003)(85306004)(104016003)(81542003)(47776003)(76176999)(20776003)(87936001)(92726001)(97756001)(83506001)(46406003)(23726002)(69596002)(50986999)(54356999)(76482002)(110136001)(33656002)(6806004)(83322001)(44976005)(85852003)(84676001)(68736004)(83072002)(64706001)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 05:22:29PM +0800, Xiubo Li-B47053 wrote:
...
> > > +	clks[LS1021A_CLK_FLEXTIMER1_EN] = ls1021a_clk_gate("flextimer1_en",
> > > +						"dummy", DCFG_CCSR_DEVDISR5,
> > > +						ls1021a_clk_shift(31));
> > 
> > So "dummy" and ls1021a_clk_shift() are two common things for every
> > single call of ls1021a_clk_gate().  Can we handle them in
> > ls1021a_clk_gate() wrapper, so that we can make these calls a bit
> > shorter?
> > 
> 
> There one gate has one parent.

Ah, yes.  I missed that.

> If the 'big-endian' will as default, I think ls1021a_clk_gate() could be handled
> In ls1021a_clk_gate() wrapper to simplify the code.

Yes, that's what I meant.

...

> > > +static inline struct clk *ls1021a_clk_gate(const char *name, const char
> > *parent,
> > > +		void __iomem *reg, u8 shift)
> > > +{
> > > +	return clk_register_gate(NULL, name, parent, CLK_SET_RATE_PARENT |
> > 
> > As the parent of the clocks registered by this function is "dummy" from
> > what I see, what is the point of setting flag CLK_SET_RATE_PARENT then?
> > 
> > > +			CLK_IGNORE_UNUSED, reg,	shift,
> > 
> > Why flag CLK_IGNORE_UNUSED?
> > 
> 
> As the SoC reference manual all the IP blocks will be enabled when powered up.
> But the Linux OS will disable all the IP blocks' clocks as default without this.
> 
> For now, this gate driver will only used for PM support of some IP blocks. For the
> Others needed to be enabled as default.

Ok, got it. I'm fine with the flag then, and we can remove it after all
those client devices manage their clocks well.

Shawn
