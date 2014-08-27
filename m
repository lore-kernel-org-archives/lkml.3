Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965552AbaH0Xdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:33:41 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:39808
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964814AbaH0Xdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:33:40 -0400
Message-ID: <1409182412.6510.129.camel@snotra.buserror.net>
Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
 CLK_OF_DECLARE support
From: Scott Wood <scottwood@freescale.com>
To: Lu Jingchang-B35083 <jingchang.lu@freescale.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 27 Aug 2014 18:33:32 -0500
In-Reply-To: <164af7b3be3747a0be3fe3a6cf83d3b1@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1408700096-25415-1-git-send-email-jingchang.lu@freescale.com>
	 <1409093463.6510.92.camel@snotra.buserror.net>
	 <164af7b3be3747a0be3fe3a6cf83d3b1@BL2PR03MB467.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:8934:4690:1c77:4b20]
X-ClientProxiedBy: BLUPR05CA0082.namprd05.prod.outlook.com (10.141.20.52) To
 BY2PR0301MB0726.namprd03.prod.outlook.com (25.160.63.16)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199003)(24454002)(51704005)(377424004)(189002)(13464003)(377454003)(64706001)(110136001)(99396002)(107046002)(101416001)(77156001)(33646002)(21056001)(76176999)(46102001)(20776003)(81542001)(50986999)(81342001)(80022001)(85306004)(47776003)(106356001)(74502001)(62966002)(74662001)(77982001)(31966008)(76482001)(23676002)(50466002)(104166001)(92726001)(92566001)(77096002)(87976001)(79102001)(89996001)(87286001)(95666004)(105586002)(86362001)(42186005)(103116003)(83322001)(83072002)(50226001)(19580405001)(102836001)(85852003)(90102001)(19580395003)(88136002)(93916002)(4396001)(99106002)(3826002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0726;H:[IPv6:2601:2:5800:3f7:8934:4690:1c77:4b20];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-26 at 21:19 -0500, Lu Jingchang-B35083 wrote:
> >-----Original Message-----
> >From: Wood Scott-B07421
> >Sent: Wednesday, August 27, 2014 6:51 AM
> >To: Lu Jingchang-B35083
> >Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
> >kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> >Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
> >CLK_OF_DECLARE support
> >
> >On Fri, 2014-08-22 at 17:34 +0800, Jingchang Lu wrote:
> >> +CLK_OF_DECLARE(ppc_core_pll_v1, "fsl,qoriq-core-pll-1.0",
> >core_pll_init);
> >> +CLK_OF_DECLARE(ppc_core_pll_v2, "fsl,qoriq-core-pll-2.0",
> >core_pll_init);
> >> +CLK_OF_DECLARE(ppc_core_mux_v1, "fsl,qoriq-core-mux-1.0",
> >core_mux_init);
> >> +CLK_OF_DECLARE(ppc_core_mux_v2, "fsl,qoriq-core-mux-2.0",
> >core_mux_init);
> >
> >What does this do that the existing platform driver and match table
> >don't?  Why is it needed for ARM when PPC didn't need it?
> >
> >-Scott
> >
> Common clk init on ARM platform is initialized earlier via of_clk_init() instead of
> driver probe method, the of_clk_init will walk a __clk_of_table to init each clk provider
> in the table, the CLK_OF_DECLARE() macro puts a supported clk in the __clk_of_table for
> it initializing on starup, and the clk system has added some common clk such as "fixed-clk"
> to this table already.
> So here I add our specific clk init declaration to consist this framework, and the driver
> probe function will not be needed on ARM.

OK... Is there any reason why the new method won't work on PPC?

-Scott


