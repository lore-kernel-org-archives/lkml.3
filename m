Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaH1QZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:25:54 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:48723
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750941AbaH1QZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:25:53 -0400
Message-ID: <1409243145.6510.160.camel@snotra.buserror.net>
Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
 CLK_OF_DECLARE support
From: Scott Wood <scottwood@freescale.com>
To: Lu Jingchang-B35083 <jingchang.lu@freescale.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 28 Aug 2014 11:25:45 -0500
In-Reply-To: <f7b4263f189346a391d66c85756b4907@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1408700096-25415-1-git-send-email-jingchang.lu@freescale.com>
	 <1409093463.6510.92.camel@snotra.buserror.net>
	 <164af7b3be3747a0be3fe3a6cf83d3b1@BL2PR03MB467.namprd03.prod.outlook.com>
	 <1409182412.6510.129.camel@snotra.buserror.net>
	 <f7b4263f189346a391d66c85756b4907@BL2PR03MB467.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:ed54:a642:fd25:83c4]
X-ClientProxiedBy: BN3PR0301CA0075.namprd03.prod.outlook.com (25.160.152.171)
 To CY1PR0301MB0730.namprd03.prod.outlook.com (25.160.159.148)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(51704005)(13464003)(24454002)(189002)(377424004)(377454003)(199003)(106356001)(104166001)(87976001)(88136002)(77982001)(23676002)(95666004)(62966002)(105586002)(86362001)(85852003)(102836001)(89996001)(93916002)(87286001)(83322001)(19580405001)(101416001)(19580395003)(83072002)(21056001)(76176999)(50986999)(103116003)(92566001)(92726001)(79102001)(77156001)(76482001)(99396002)(50466002)(74502001)(74662001)(31966008)(107046002)(46102001)(33646002)(110136001)(77096002)(90102001)(81542001)(47776003)(64706001)(42186005)(80022001)(20776003)(93886004)(85306004)(50226001)(4396001)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0730;H:[IPv6:2601:2:5800:3f7:ed54:a642:fd25:83c4];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-28 at 05:05 -0500, Lu Jingchang-B35083 wrote:
> >-----Original Message-----
> >From: Wood Scott-B07421
> >Sent: Thursday, August 28, 2014 7:34 AM
> >To: Lu Jingchang-B35083
> >Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
> >kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> >Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
> >CLK_OF_DECLARE support
> >
> >On Tue, 2014-08-26 at 21:19 -0500, Lu Jingchang-B35083 wrote:
> >> >-----Original Message-----
> >> >From: Wood Scott-B07421
> >> >Sent: Wednesday, August 27, 2014 6:51 AM
> >> >To: Lu Jingchang-B35083
> >> >Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
> >> >kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> >> >Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based
> >> >platforms CLK_OF_DECLARE support
> >> >
> >> >On Fri, 2014-08-22 at 17:34 +0800, Jingchang Lu wrote:
> >> >> +CLK_OF_DECLARE(ppc_core_pll_v1, "fsl,qoriq-core-pll-1.0",
> >> >core_pll_init);
> >> >> +CLK_OF_DECLARE(ppc_core_pll_v2, "fsl,qoriq-core-pll-2.0",
> >> >core_pll_init);
> >> >> +CLK_OF_DECLARE(ppc_core_mux_v1, "fsl,qoriq-core-mux-1.0",
> >> >core_mux_init);
> >> >> +CLK_OF_DECLARE(ppc_core_mux_v2, "fsl,qoriq-core-mux-2.0",
> >> >core_mux_init);
> >> >
> >> >What does this do that the existing platform driver and match table
> >> >don't?  Why is it needed for ARM when PPC didn't need it?
> >> >
> >> >-Scott
> >> >
> >> Common clk init on ARM platform is initialized earlier via
> >> of_clk_init() instead of driver probe method, the of_clk_init will
> >> walk a __clk_of_table to init each clk provider in the table, the
> >> CLK_OF_DECLARE() macro puts a supported clk in the __clk_of_table for it
> >initializing on starup, and the clk system has added some common clk such
> >as "fixed-clk"
> >> to this table already.
> >> So here I add our specific clk init declaration to consist this
> >> framework, and the driver probe function will not be needed on ARM.
> >
> >OK... Is there any reason why the new method won't work on PPC?
> >
> PPC has little dependence on the clock tree but frequency, it will work well
> if adopted I think.

I'm just saying it seems redundant to have both.  Even on ARM, won't
this result in the clock getting registered twice (albeit with one of
those times being too late)?

Regardless of what dependence PPC has on the clock tree, what stops this
method of enumeration from working on PPC?  Is there anything required
other than inserting a call to of_clk_init(NULL) in the arch init code?

-Scott


