Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaIQIoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:44:54 -0400
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:15736
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751826AbaIQIot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:44:49 -0400
Date: Wed, 17 Sep 2014 16:51:08 +0800
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
Message-ID: <20140917085106.GB6369@Robin-OptiPlex-780>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
 <5416D26A.4080707@ahsoftware.de> <20140916035204.GB20800@Robin-OptiPlex-780>
 <541805E3.6080003@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <541805E3.6080003@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(51704005)(93886004)(85306004)(46406003)(79102003)(74502003)(80022003)(50986999)(102836001)(33656002)(83506001)(76176999)(54356999)(33716001)(23726002)(110136001)(97736003)(99396002)(64706001)(50466002)(47776003)(104016003)(20776003)(87936001)(90102001)(74662003)(84676001)(26826002)(81342003)(46102003)(81542003)(77982003)(85852003)(83072002)(92726001)(92566001)(6806004)(31966008)(19580405001)(19580395003)(83322001)(44976005)(97756001)(21056001)(4396001)(106466001)(68736004)(76482002)(105606002)(107046002)(95666004)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB374;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 11:41:55AM +0200, Alexander Holler wrote:
> Am 16.09.2014 05:52, schrieb Robin Gong:
> >On Mon, Sep 15, 2014 at 01:50:02PM +0200, Alexander Holler wrote:
> >>Am 10.09.2014 07:30, schrieb Robin Gong:
> >>>There is one weird data in rxfifo after one full rx/tx transfer
> >>>done sometimes. It looks a design issue and hard to workaround
> >>>totally, so disable dma functhion here. And will re-enable it
> >>>once the root cause found.
> >>
> >>Hmm, I experience problems with DMA too but on uart3. I'm using the same
> >>workaround for the uart (I've just commented out the dma entries in the DT).
> >>The problem manifests itself here such, that brcm_patchram_plus
> >>hangs while uploading the firmware to a BCM4330 connected at uart3
> >>(reproducible).
> >>
> >>So maybe there is a bug in the DMA-engine which not only effects
> >>SPI. Or both drivers contain the same error in handling DMA (maybe
> >>through c&p).
> >>But that's just specualtion from me, I haven't looked further into
> >>that problem.
> >>
> >>Regards,
> >>
> >>Alexander Holler
> >Thanks for your information share. But my issue should be caused by hardware,
> >since everything is ok if it runs on other i.mx6 chip. Is your board also based
> >on i.mx6 chip? If yes, hope you can raise your issue in freescale community or
> >contact with Andy whose mail address added in CC list fugang.duan@freescale.cm.
> >We have fix some bugs in UART DMA case.
> 
> It's an i.mx6q (Wandboard quad c1) where I have this problem with
> mainline and much older (but heavily patched freescale 3.10.x based)
> kernels. A quick web-search suggests that this problem exists since
> a long time (noticed mainly by people which try to use BT as this
> seems to be the major use case for high speed serial communication).
> 
> Regards,
> 
> Alexander Holler
Yes, we just have fixed the BT issue over high speed UART last month. Suggest
you trying our patches based on v3.10.
