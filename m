Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaGNODn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:03:43 -0400
Received: from [207.46.163.141] ([207.46.163.141]:35362 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755581AbaGNODN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:03:13 -0400
Date: Mon, 14 Jul 2014 22:02:24 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <mkl@pengutronix.de>, <kernel@pengutronix.de>,
        Jingchang Lu <b35083@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] ARM: imx: clk-vf610: fix FlexCAN clock gating
Message-ID: <20140714140223.GI2197@dragon>
References: <cover.1405322992.git.stefan@agner.ch>
 <94282392d8355ac25bb998b89032c1c980d5ccce.1405322992.git.stefan@agner.ch>
 <20140714133926.GH2197@dragon> <5a57efd52b0092ad61ff6a2b5bf68ba7@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5a57efd52b0092ad61ff6a2b5bf68ba7@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51914003)(199002)(189002)(24454002)(51704005)(92566001)(92726001)(4396001)(83072002)(95666004)(80022001)(81156004)(87936001)(106466001)(85852003)(31966008)(50466002)(47776003)(20776003)(93886003)(54356999)(76176999)(50986999)(99396002)(105606002)(74662001)(6806004)(64706001)(44976005)(23726002)(79102001)(84676001)(81342001)(110136001)(57986006)(86362001)(85306003)(107046002)(33656002)(76482001)(77982001)(33716001)(26826002)(74502001)(21056001)(83322001)(97736001)(97756001)(81542001)(102836001)(83506001)(104016003)(68736004)(69596002)(46102001)(46406003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB477;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 03:55:29PM +0200, Stefan Agner wrote:
> There are two enable (gates) bits to enable the FlexCAN clocks: the
> first is in the divider register, the second in the clock gate register.
> For most clocks there is a divider in between, then it looks like this:
> 
> clk[VF610_CLK_ESDHC0_SEL] = imx_clk_mux("esdhc0_sel", CCM_CSCMR1, 16, 2,
> esdhc_sels, 4);
> clk[VF610_CLK_ESDHC0_EN] = imx_clk_gate("esdhc0_en", "esdhc0_sel",
> CCM_CSCDR2, 28);
> clk[VF610_CLK_ESDHC0_DIV] = imx_clk_divider("esdhc0_div", "esdhc0_en",
> CCM_CSCDR2, 16, 4);
> clk[VF610_CLK_ESDHC0] = imx_clk_gate2("eshc0", "esdhc0_div", CCM_CCGR7,
> CCM_CCGRx_CGn(1));
> 
> However, for FlexCAN no clock selection and no divider is available,
> hence its just a chain of an enable and gate register...

Ah, okay.  Thanks for the explanation.

Shawn
