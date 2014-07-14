Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaGNHcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:32:54 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:13671
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752785AbaGNHcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:32:46 -0400
Date: Mon, 14 Jul 2014 15:32:35 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, <wg@grandegger.com>,
        <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: flexcan: add vf61x support for flexcan
Message-ID: <20140714073234.GD2197@dragon>
References: <1405075933-22317-1-git-send-email-stefan@agner.ch>
 <53BFD401.8030101@pengutronix.de> <dac76ccd134f41b86f00352d10cfae4b@agner.ch>
 <20140714060344.GB2197@dragon> <cecd42e333cdf65ad512f719125f9180@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cecd42e333cdf65ad512f719125f9180@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(377424004)(24454002)(51704005)(189002)(199002)(21056001)(50466002)(4396001)(97756001)(81542001)(79102001)(86362001)(50986999)(76176999)(97736001)(95666004)(81342001)(54356999)(99396002)(81156004)(105606002)(64706001)(106466001)(80022001)(85306003)(20776003)(110136001)(46102001)(104016003)(57986006)(83072002)(92726001)(85852003)(92566001)(46406003)(74662001)(87936001)(74502001)(31966008)(83322001)(107046002)(77982001)(33656002)(33716001)(76482001)(44976005)(6806004)(47776003)(84676001)(23726002)(68736004)(102836001)(83506001)(69596002)(19580405001)(93886003)(26826002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB374;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:06:33AM +0200, Stefan Agner wrote:
> Am 2014-07-14 08:04, schrieb Shawn Guo:
> > On Fri, Jul 11, 2014 at 03:58:37PM +0200, Stefan Agner wrote:
> >> >> @@ -362,7 +374,7 @@
> >> >>
> >> >>  			esdhc1: esdhc@400b2000 {
> >> >>  				compatible = "fsl,imx53-esdhc";
> >> >> -				reg = <0x400b2000 0x4000>;
> >> >> +				reg = <0x400b2000 0x1000>;
> >> >
> >> > What's that doing here? :)
> >>
> >> That's an error I just stumbled upon.
> > 
> > I do not see why it's an error.  From Table 2-1. System Memory Map in
> > i.MX53 RM, the size of ESDHC1 is 16K.
> > 
> > Shawn
> 
> Hi Shawn,
> 
> In the Vybrid RM memory map, 0x400B4000 is allocated to USB. 0x400B3000
> is empty, whereas for other peripherals (e.g. FlexCAN) which use
> multiple 0x1000 blocks, they are all explicitly stated. That is why I
> assumed 0x1000 is correct.

Ah, sorry.  I thought you're on i.MX53.  You're right about Vybrid, and
it should be 0x1000.

> 
> But then, the memory map within the SDHC peripheral has some registers
> also located in 0x400B3000.

Really?  Which one?

Shawn

> Hence I think 0x2000 is correct. Will send
> an updated and separated patch.
