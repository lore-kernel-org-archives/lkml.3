Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbaGNOEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:04:23 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:25164
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755175AbaGNOER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:04:17 -0400
Date: Mon, 14 Jul 2014 22:04:05 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Stefan Agner <stefan@agner.ch>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] ARM: vf610: add FlexCAN support
Message-ID: <20140714140404.GJ2197@dragon>
References: <cover.1405322992.git.stefan@agner.ch>
 <53C39052.7040400@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53C39052.7040400@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(479174003)(24454002)(51704005)(377454003)(199002)(189002)(19580395003)(33716001)(106466001)(105606002)(77982001)(81156004)(87936001)(86362001)(81342001)(84676001)(85306003)(23726002)(81542001)(26826002)(64706001)(76482001)(57986006)(97736001)(99396002)(83072002)(31966008)(46406003)(21056001)(44976005)(85852003)(68736004)(74662001)(47776003)(95666004)(107046002)(33656002)(80022001)(102836001)(97756001)(76176999)(92566001)(83322001)(50986999)(92726001)(83506001)(46102001)(110136001)(104016003)(74502001)(54356999)(6806004)(20776003)(4396001)(50466002)(69596002)(79102001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB370;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:09:54AM +0200, Marc Kleine-Budde wrote:
> On 07/14/2014 09:48 AM, Stefan Agner wrote:
> > This series adds support for Vybrid (aka vf610) to the FlexCAN
> > controller and extends the device tree accordingly.
> > 
> > Changes in v2:
> > - Split out patch (seperate dt, clocks and driver changes)
> > - Use spaces for hardware feature flags table
> > - Remove drive-by change of esdhc register length
> > - Added related fix which enables clock in berr_counter
> > 
> > Stefan Agner (4):
> >   ARM: dts: vf610: add FlexCAN node
> >   ARM: imx: clk-vf610: fix FlexCAN clock gating
> >   can: flexcan: switch on clocks before accessing ecr register
> >   can: flexcan: add vf610 support for FlexCAN
> > 
> >  arch/arm/boot/dts/vf610.dtsi  | 23 +++++++++++
> >  arch/arm/mach-imx/clk-vf610.c |  6 ++-
> >  drivers/net/can/flexcan.c     | 89 ++++++++++++++++++++++++++++++++++++++-----
> >  3 files changed, 106 insertions(+), 12 deletions(-)
> 
> Shawn, what's the best way to upstream this? With your Ack, I can take
> everything via linux-can-next.

Since this is a new support and there is nothing to maintain git bisect,
I think the best way is to have the first two patches to go via my tree.

Shawn
