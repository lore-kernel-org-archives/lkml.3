Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaIOL7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:59:22 -0400
Received: from mail-bn1bn0107.outbound.protection.outlook.com ([157.56.110.107]:41472
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753705AbaIOL7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:59:21 -0400
Date: Mon, 15 Sep 2014 19:58:56 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V1 1/3] ARM: clk-imx6sl: refine clock tree for SSI
Message-ID: <20140915115855.GC23877@audiosh1>
References: <cover.1410253534.git.shengjiu.wang@freescale.com>
 <7ed21195ebff8b3ccbecaeb492504edd28deea2d.1410253534.git.shengjiu.wang@freescale.com>
 <CAOMZO5A4FLbA_+u4oMTqgAY69DaF93V=oLiy+op=tEHbagF1pg@mail.gmail.com>
 <CAOMZO5DJZHKAV4Y9aUwMNWZqhoLrKrsZdYnKqPem2ZSy=-oAYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOMZO5DJZHKAV4Y9aUwMNWZqhoLrKrsZdYnKqPem2ZSy=-oAYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(377454003)(189002)(199003)(110136001)(90102001)(47776003)(85306004)(26826002)(50466002)(33716001)(20776003)(92726001)(105606002)(64706001)(85852003)(80022001)(46406003)(97756001)(102836001)(19580405001)(81342001)(33656002)(84676001)(107046002)(23726002)(86362001)(68736004)(44976005)(97736003)(83322001)(83506001)(106466001)(21056001)(1411001)(6806004)(79102001)(104016003)(77982001)(19580395003)(4396001)(46102001)(74662001)(95666004)(92566001)(93886004)(31966008)(99396002)(50986999)(54356999)(83072002)(76482001)(81542001)(87936001)(74502001)(76176999);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB339;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB339;
X-Forefront-PRVS: 03355EE97E
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi fabio, shawn.

On Fri, Sep 12, 2014 at 01:43:39PM -0300, Fabio Estevam wrote:
> On Fri, Sep 12, 2014 at 1:35 PM, Fabio Estevam <festevam@gmail.com> wrote:
> > On Tue, Sep 9, 2014 at 6:13 AM, Shengjiu Wang
> > <shengjiu.wang@freescale.com> wrote:
> >> Each SSI has "ssi", "ssi_ipg" clocks, and they share same gate bits.
> >>
> >> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> >
> > This patch breaks audio playback on imx6q-sabresd:
> >
> > root@freescale /$ aplay /home/clarinet.wav
> > Playing WAVE '/home/clarinet.wav' : Signed 16 bit Little Endian, Rate 44100 Hz,
> > Mono
> > underrun!!! (at least -1585992.581 ms long)
> > underrun!!! (at least -1585992.585 ms long)
> > underrun!!! (at least -1585992.586 ms long)
> > underrun!!! (at least -1585992.586 ms long)
> > underrun!!! (at least -1585992.586 ms long)
> > underrun!!! (at least -1585992.586 ms long)
> > underrun!!! (at least -1585992.586 ms long)
> > underrun!!! (at least -1585992.586 ms long)
> > underrun!!! (at least -1585992.586 ms long)
> > underrun!!! (at least -1585992.586 ms long)
> >
> > If I revert this commit, then I am able to play it well again.
> 
> Ops, I replied in the wrong patch.
> 
> The one that breaks imx6q-sabresd is:
> 
>    commit 48e1c2255 "ARM: clk-imx6q: refine clock tree for SSI"

I add IMX6QDL_CLK_SSIx in this patch, which use share count with 
IMX6QDL_CLK_SSIx_IPG. The SSI driver sound/soc/fsl/fsl_ssi.c will enable
IMX6QDL_CLK_SSIx_IPG clock in probe, but don't disable it. In the end of kernel
boot up, some one(it is not ssi driver, maybe is the clock tree) will disable
the IMX6QDL_CLK_SSIx clock, which is not enabled. IMX6QDL_CLK_SSIx_IPG share
the enable/disable bit with IMX6QDL_CLK_SSIx, So IMX6QDL_CLK_SSIx_IPG is 
disabled, the aplay will fail.

Is this the issue of imx_clk_gate2_shared()? When we want to disable IMX6QDL_CLK_SSIx,
but IMX6QDL_CLK_SSIx_IPG is enabled, can IMX6QDL_CLK_SSIx be disabled?


Shawn

   How do you think about this?

best regards
wang shengjiu
