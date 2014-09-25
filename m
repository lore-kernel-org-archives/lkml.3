Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaIYJWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:22:37 -0400
Received: from mail-bn1on0130.outbound.protection.outlook.com ([157.56.110.130]:22124
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbaIYJWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:22:34 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shengchao Guo <Shawn.Guo@freescale.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3] ARM: ls1021a: add gating clocks to IP blocks.
Thread-Topic: [PATCH v3] ARM: ls1021a: add gating clocks to IP blocks.
Thread-Index: AQHP1yw1xpt6riX400mCXn9hhSG2j5wRjisAgAAB8dA=
Date: Thu, 25 Sep 2014 09:22:29 +0000
Message-ID: <e44a1930e8de43ec8beb6e60fa9c1e9e@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411476275-9164-1-git-send-email-Li.Xiubo@freescale.com>
 <20140925085403.GG6405@dragon>
In-Reply-To: <20140925085403.GG6405@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB337;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(164054003)(80022003)(76576001)(20776003)(81542003)(74502003)(90102001)(107046002)(86362001)(64706001)(92566001)(79102003)(110136001)(66066001)(46102003)(33646002)(77982003)(77096002)(83072002)(81342003)(74662003)(95666004)(99286002)(83322001)(101416001)(54356999)(108616004)(76176999)(74316001)(50986999)(85306004)(31966008)(4396001)(76482002)(97736003)(10300001)(85852003)(106116001)(105586002)(99396003)(106356001)(87936001)(2656002)(21056001)(120916001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB337;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[...]
> > +Required properties:
> > +- compatible:		Should be "fsl,ls1021a-gate"
> > +- reg:			Address and length of the register set
> > +- #clock-cells:		Should be <1>
> > +
> > +Optional property:
> > +- big-endian:		If present the gate clock base registers are
> > +			implemented in big endian mode, otherwise in
> > +			little mode.
> 
> Do you have a real world example that has the block work in little
> endian?  Otherwise, I suggest we make big-endian the default and save
> the property for now.
> 
On ls1 it is big-endian, not sure will be little-endian in another version.

Maybe add this if need in the future is better ? if so, I will remove this.



[...]
> > +
> > +	BUG_ON(!clk_data || !clks);
> > +
> > +	dcfg_base = of_iomap(np, 0);
> > +
> > +	BUG_ON(!dcfg_base);
> > +
> > +	if (of_property_read_bool(np, "big-endian"))
> > +		ls1021a_clk_shift = ls1021a_clk_shift_be;
> 
> Suggest to make this default and save the property for now.
> 

Okay. I will have a look at this.

> > +
> > +	clks[LS1021A_CLK_PBL_EN] = ls1021a_clk_gate("pbl_en", "dummy",
> 
> So the parent of all these gate clocks are "dummy".  Does it mean that
> the clock tree on LS1021A consists of only gate clocks? No dividers
> or multiplexers?
> 

Yes, only gate clocks.

> > +						DCFG_CCSR_DEVDISR1,
> > +						ls1021a_clk_shift(0));
> 
> I think we can ignore the 80 columns warning and put these on one line
> to make the code a bit easier to read.
> 

Okay, as you have agreed, I will put these on one line.


[...]
> > +	clks[LS1021A_CLK_I2C1_EN] = ls1021a_clk_gate("i2c1_en", "dummy",
> > +						DCFG_CCSR_DEVDISR5,
> > +						ls1021a_clk_shift(29));
> > +	clks[LS1021A_CLK_LPUART1_EN] = ls1021a_clk_gate("lpuart1_en", "dummy",
> > +						DCFG_CCSR_DEVDISR5,
> > +						ls1021a_clk_shift(30));
> > +	clks[LS1021A_CLK_FLEXTIMER1_EN] = ls1021a_clk_gate("flextimer1_en",
> > +						"dummy", DCFG_CCSR_DEVDISR5,
> > +						ls1021a_clk_shift(31));
> 
> So "dummy" and ls1021a_clk_shift() are two common things for every
> single call of ls1021a_clk_gate().  Can we handle them in
> ls1021a_clk_gate() wrapper, so that we can make these calls a bit
> shorter?
> 

There one gate has one parent.
If the 'big-endian' will as default, I think ls1021a_clk_gate() could be handled
In ls1021a_clk_gate() wrapper to simplify the code.

> > +
> > +	for (i = 0; i < LS1021A_CLK_END; i++) {
> > +		if (IS_ERR(clks[i])) {
> > +			pr_err("LS1021A clk %d: register failed with %ld\n",
> > +			       i, PTR_ERR(clks[i]));
> > +			BUG();
> > +		}
> > +	}
> > +
> > +	/* Add the clocks to provider list */
> > +	clk_data->clks = clks;
> > +	clk_data->clk_num = LS1021A_CLK_END;
> > +	of_clk_add_provider(np, of_clk_src_onecell_get, clk_data);
> > +}
> > +CLK_OF_DECLARE(ls1021a, "fsl,ls1021a-gate", ls1021a_clocks_init);
> > diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
> > index 4cdf8b6..cfbae8c 100644
> > --- a/arch/arm/mach-imx/clk.h
> > +++ b/arch/arm/mach-imx/clk.h
> > @@ -107,6 +107,14 @@ static inline struct clk *imx_clk_gate_dis(const char
> *name, const char *parent,
> >  			shift, CLK_GATE_SET_TO_DISABLE, &imx_ccm_lock);
> >  }
> >
> > +static inline struct clk *ls1021a_clk_gate(const char *name, const char
> *parent,
> > +		void __iomem *reg, u8 shift)
> > +{
> > +	return clk_register_gate(NULL, name, parent, CLK_SET_RATE_PARENT |
> 
> As the parent of the clocks registered by this function is "dummy" from
> what I see, what is the point of setting flag CLK_SET_RATE_PARENT then?
> 
> > +			CLK_IGNORE_UNUSED, reg,	shift,
> 
> Why flag CLK_IGNORE_UNUSED?
> 

As the SoC reference manual all the IP blocks will be enabled when powered up.
But the Linux OS will disable all the IP blocks' clocks as default without this.

For now, this gate driver will only used for PM support of some IP blocks. For the
Others needed to be enabled as default.

I'm thinking how about just adding the gates needed, for the others add them later
When they are needed in the future ?

Thanks,

BRs
Xiubo
