Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaIQIe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:34:59 -0400
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:4768
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751660AbaIQIe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:34:56 -0400
Date: Wed, 17 Sep 2014 16:41:22 +0800
From: Robin Gong <b38343@freescale.com>
To: Lucas Stach <l.stach@pengutronix.de>
CC: <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@pengutronix.de>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
Message-ID: <20140917084120.GA6369@Robin-OptiPlex-780>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
 <1410774073.3314.1.camel@pengutronix.de>
 <20140916034123.GA20800@Robin-OptiPlex-780>
 <1410861006.2746.1.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410861006.2746.1.camel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51444003)(199003)(51704005)(24454002)(50466002)(6806004)(102836001)(31966008)(20776003)(77982003)(19580395003)(104016003)(84676001)(44976005)(21056001)(23726002)(68736004)(4396001)(97736003)(83322001)(93886004)(92566001)(15202345003)(81342003)(87936001)(33716001)(33656002)(50986999)(83072002)(26826002)(54356999)(76176999)(80022003)(99396002)(83506001)(15975445006)(90102001)(79102003)(85852003)(74662003)(64706001)(95666004)(47776003)(107046002)(105606002)(46406003)(106466001)(97756001)(76482002)(81542003)(74502003)(92726001)(110136001)(85306004)(46102003)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB339;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB339;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 11:50:06AM +0200, Lucas Stach wrote:
> Hi Robin,
> 
> Am Dienstag, den 16.09.2014, 11:41 +0800 schrieb Robin Gong:
> > Hi Lucas,
> >   I understood your concern,but looks we have to break old DT.
> 
> Sorry, but this isn't going to happen. And honestly I don't even see the
> need to do so.
> 
> > Our old DT
> > support SPI DMA on i.mx6q/dl(v2,b3810c3dc1bcbc6a), but the DMA support patch
> > for SPI driver is still in reviewing(v6).
> 
> So this means now is the time to fix this driver patch to not enable DMA
> on imx6dl. Nobody will experience any breakage in this case.
>
Sorry, i.mx6q and i.mx6dl are totally same, not only IP but also clock. So we
can't distinguish them except for different compatible name....
> > So the violation you mentioned comes
> > if someone use the DT during the time(from v2 to spi driver patch upstreamed).
> >   The different behaviors on different chips(only i.mxdl can't pass strength
> > test) are just found from last month, this is why I sent the patch for disable
> > SPI DMA support on i.mx6dl during I sent v6 patch for spi driver. I think that's
> > make sense, because DTs are also in development, new difference between different
> > chips maybe found in the future although they share the same IP....
> >   Yes, I can check cpu type by looking at DT in spi driver, but it's not nice.
> 
> Yeah it would have been nicer if we had an explicit DT compatible for
> the imx6dl ecspi version, but it's not there, so we have to cope with
> this.
> 
> > So I'm afraid that we have to break the old DTs in the gap between the two
> > levels patch accepted cycle.
> > 
> > On Mon, Sep 15, 2014 at 11:41:13AM +0200, Lucas Stach wrote:
> > > Am Mittwoch, den 10.09.2014, 13:30 +0800 schrieb Robin Gong:
> > > > There is one weird data in rxfifo after one full rx/tx transfer
> > > > done sometimes. It looks a design issue and hard to workaround
> > > > totally, so disable dma functhion here. And will re-enable it
> > > > once the root cause found.
> > > > 
> > > Sorry, I'm late to this as Shawn seems to already have picked up this
> > > patch, but this isn't the right way to fix the problem.
> > > 
> > > We made it clear at kernel summit last year that we try to not break
> > > existing DTs as booting a new kernel with an old DT is a valid use case.
> > > While you don't strictly violate this rule what you do here is only
> > > fixing systems booting with a new DT while leaving others broken.
> > > 
> > > If you are working around a hardware problem please disable DMA support
> > > in the driver. This will also allow you to enable it again, if you find
> > > another workaround without touching the DT again.
> > > 
> > > So this patch gets a NAK from me.
> > > 
> 
> Regards,
> Lucas
> -- 
> Pengutronix e.K.             | Lucas Stach                 |
> Industrial Linux Solutions   | http://www.pengutronix.de/  |
> 
