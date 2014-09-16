Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaIPDpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:45:40 -0400
Received: from mail-bn1on0135.outbound.protection.outlook.com ([157.56.110.135]:20160
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753541AbaIPDpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:45:39 -0400
Date: Tue, 16 Sep 2014 11:52:05 +0800
From: Robin Gong <b38343@freescale.com>
To: Alexander Holler <holler@ahsoftware.de>
CC: <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fugang.duan@freescale.com>
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
Message-ID: <20140916035204.GB20800@Robin-OptiPlex-780>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
 <5416D26A.4080707@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5416D26A.4080707@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(51704005)(189002)(46406003)(50466002)(97756001)(87936001)(76482001)(106466001)(4396001)(31966008)(102836001)(95666004)(85306004)(33656002)(105606002)(46102003)(77982003)(79102003)(81342003)(19580395003)(80022003)(74502003)(81542003)(74662003)(21056001)(44976005)(110136001)(107046002)(90102001)(20776003)(85852003)(97736003)(83322001)(104016003)(83072002)(23726002)(92566001)(99396002)(26826002)(76176999)(33716001)(54356999)(84676001)(47776003)(68736004)(64706001)(50986999)(83506001)(19580405001)(6806004)(92726001)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB352;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 01:50:02PM +0200, Alexander Holler wrote:
> Am 10.09.2014 07:30, schrieb Robin Gong:
> >There is one weird data in rxfifo after one full rx/tx transfer
> >done sometimes. It looks a design issue and hard to workaround
> >totally, so disable dma functhion here. And will re-enable it
> >once the root cause found.
> 
> Hmm, I experience problems with DMA too but on uart3. I'm using the same
> workaround for the uart (I've just commented out the dma entries in the DT).
> The problem manifests itself here such, that brcm_patchram_plus
> hangs while uploading the firmware to a BCM4330 connected at uart3
> (reproducible).
> 
> So maybe there is a bug in the DMA-engine which not only effects
> SPI. Or both drivers contain the same error in handling DMA (maybe
> through c&p).
> But that's just specualtion from me, I haven't looked further into
> that problem.
> 
> Regards,
> 
> Alexander Holler
Thanks for your information share. But my issue should be caused by hardware,
since everything is ok if it runs on other i.mx6 chip. Is your board also based
on i.mx6 chip? If yes, hope you can raise your issue in freescale community or
contact with Andy whose mail address added in CC list fugang.duan@freescale.cm.
We have fix some bugs in UART DMA case.
