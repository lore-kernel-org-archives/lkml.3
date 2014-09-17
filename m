Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaIQJVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:21:54 -0400
Received: from mail-bl2on0108.outbound.protection.outlook.com ([65.55.169.108]:14825
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754251AbaIQJVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:21:52 -0400
Date: Wed, 17 Sep 2014 17:28:25 +0800
From: Robin Gong <b38343@freescale.com>
To: Lucas Stach <l.stach@pengutronix.de>
CC: <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
Message-ID: <20140917092823.GB6551@Robin-OptiPlex-780>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
 <1410774073.3314.1.camel@pengutronix.de>
 <20140916034123.GA20800@Robin-OptiPlex-780>
 <1410861006.2746.1.camel@pengutronix.de>
 <20140917084120.GA6369@Robin-OptiPlex-780>
 <1410944156.2731.1.camel@pengutronix.de>
 <20140917091922.GA6551@Robin-OptiPlex-780>
 <1410945574.2731.3.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410945574.2731.3.camel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(199003)(24454002)(95666004)(105606002)(97756001)(76176999)(97736003)(106466001)(46406003)(76482002)(83322001)(33656002)(44976005)(54356999)(19580395003)(83072002)(92566001)(84676001)(83506001)(15975445006)(92726001)(74662003)(23726002)(4396001)(64706001)(21056001)(33716001)(6806004)(68736004)(47776003)(20776003)(99396002)(50986999)(87936001)(31966008)(77982003)(79102003)(81342003)(107046002)(46102003)(93886004)(110136001)(85852003)(104016003)(50466002)(74502003)(80022003)(85306004)(90102001)(102836001)(15202345003)(26826002)(81542003)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB350;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB350;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:19:34AM +0200, Lucas Stach wrote:
> Am Mittwoch, den 17.09.2014, 17:19 +0800 schrieb Robin Gong:
> > On Wed, Sep 17, 2014 at 10:55:56AM +0200, Lucas Stach wrote:
> > > Am Mittwoch, den 17.09.2014, 16:41 +0800 schrieb Robin Gong:
> > > > On Tue, Sep 16, 2014 at 11:50:06AM +0200, Lucas Stach wrote:
> > > > > Hi Robin,
> > > > > 
> > > > > Am Dienstag, den 16.09.2014, 11:41 +0800 schrieb Robin Gong:
> > > > > > Hi Lucas,
> > > > > >   I understood your concern,but looks we have to break old DT.
> > > > > 
> > > > > Sorry, but this isn't going to happen. And honestly I don't even see the
> > > > > need to do so.
> > > > > 
> > > > > > Our old DT
> > > > > > support SPI DMA on i.mx6q/dl(v2,b3810c3dc1bcbc6a), but the DMA support patch
> > > > > > for SPI driver is still in reviewing(v6).
> > > > > 
> > > > > So this means now is the time to fix this driver patch to not enable DMA
> > > > > on imx6dl. Nobody will experience any breakage in this case.
> > > > >
> > > > Sorry, i.mx6q and i.mx6dl are totally same, not only IP but also clock. So we
> > > > can't distinguish them except for different compatible name....
> > > 
> > > I know that, but I still don't see the problem.
> > > 
> > > If this issue is specific to the ECSPI IP integrated into a imx6dl SoC
> > > you need to check for the machine compatible in the driver and disable
> > > DMA support based on this. We generally avoid checking for the machine
> > > compatible in drivers and prefer to have a specific IP block compatible
> > > instead, but in that case it's the only reasonable thing to do.
> > > 
> > > Regards,
> > > Lucas
> > Sounds we make a agreement on use different compatible name, right? I will
> > make patch for reviewing, thanks.
> 
> No you can't use a new compatible name for the IP block, as this again
> would only fix things for users with new devicetrees. Also this has
> nothing to do with the IP block, but is an integration issue between
> ECPSI and imx6dl.
> 
> So what you need to do is something like this in the ecspi kernel
> driver:
> 
> if (of_machine_is_compatible("fsl,imx6dl") {
>     do_whatever_is_necessary_to_make_sure_DMA_is_not_enabled();
> }
> 
> Regards,
> Lucas
Sure, the ecspi kernel driver must check the new compatible name for i.mx6dl.
> -- 
> Pengutronix e.K.             | Lucas Stach                 |
> Industrial Linux Solutions   | http://www.pengutronix.de/  |
> 
