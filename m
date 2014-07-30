Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaG3CpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:45:01 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:38558
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751895AbaG3CpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 22:45:00 -0400
Date: Wed, 30 Jul 2014 10:44:46 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <peter.chen@freescale.com>,
        <jingchang.lu@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: imx: clk-vf610: introduce clks_init_on
Message-ID: <20140730024445.GB10206@dragon>
References: <1406643628-4061-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1406643628-4061-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(24454002)(51704005)(26826002)(77982001)(19580395003)(79102001)(95666004)(57986006)(31966008)(33656002)(74662001)(19580405001)(102836001)(106466001)(23726002)(105606002)(83322001)(86362001)(47776003)(85306003)(76176999)(54356999)(44976005)(46406003)(97756001)(20776003)(97736001)(50986999)(80022001)(110136001)(50466002)(6806004)(64706001)(81542001)(21056001)(107046002)(33716001)(104016003)(76482001)(99396002)(74502001)(68736004)(83072002)(84676001)(81342001)(83506001)(4396001)(46102001)(92566001)(92726001)(87936001)(85852003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB467;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0288CD37D9
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 04:20:28PM +0200, Stefan Agner wrote:
> At the end of the boot process, the clock framework might disable
> required main PLL's. So far, this was no issue since drivers
> requested clocks, which are descended of the main PLL's (e.g.
> pll1_pfd1, which provides the system clock).
> 
> To archive the full 500MHz system clock, DDR clock need to be a
> descendant of PLL2 rather than PLL1 (DDRC_CLK_SEL set to 0). The
> bootloader sets up the clocks accordingly before making use of
> DDR at all. However, in Linux, there is no driver using PLL2,
> which lead to PLL2 being disabled by the clock framework.
> 
> With this patch, we make sure that the main system clock and the
> DDR clock are initially enabled and are kept enabled.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Applied, thanks.
