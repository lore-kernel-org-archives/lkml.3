Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaIPJu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:50:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36484 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaIPJuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:50:25 -0400
Message-ID: <1410861006.2746.1.camel@pengutronix.de>
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
From: Lucas Stach <l.stach@pengutronix.de>
To: Robin Gong <b38343@freescale.com>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        galak@codeaurora.org, shawn.guo@freescale.com
Date: Tue, 16 Sep 2014 11:50:06 +0200
In-Reply-To: <20140916034123.GA20800@Robin-OptiPlex-780>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
	 <1410774073.3314.1.camel@pengutronix.de>
	 <20140916034123.GA20800@Robin-OptiPlex-780>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robin,

Am Dienstag, den 16.09.2014, 11:41 +0800 schrieb Robin Gong:
> Hi Lucas,
>   I understood your concern,but looks we have to break old DT.

Sorry, but this isn't going to happen. And honestly I don't even see the
need to do so.

> Our old DT
> support SPI DMA on i.mx6q/dl(v2,b3810c3dc1bcbc6a), but the DMA support patch
> for SPI driver is still in reviewing(v6).

So this means now is the time to fix this driver patch to not enable DMA
on imx6dl. Nobody will experience any breakage in this case.

> So the violation you mentioned comes
> if someone use the DT during the time(from v2 to spi driver patch upstreamed).
>   The different behaviors on different chips(only i.mxdl can't pass strength
> test) are just found from last month, this is why I sent the patch for disable
> SPI DMA support on i.mx6dl during I sent v6 patch for spi driver. I think that's
> make sense, because DTs are also in development, new difference between different
> chips maybe found in the future although they share the same IP....
>   Yes, I can check cpu type by looking at DT in spi driver, but it's not nice.

Yeah it would have been nicer if we had an explicit DT compatible for
the imx6dl ecspi version, but it's not there, so we have to cope with
this.

> So I'm afraid that we have to break the old DTs in the gap between the two
> levels patch accepted cycle.
> 
> On Mon, Sep 15, 2014 at 11:41:13AM +0200, Lucas Stach wrote:
> > Am Mittwoch, den 10.09.2014, 13:30 +0800 schrieb Robin Gong:
> > > There is one weird data in rxfifo after one full rx/tx transfer
> > > done sometimes. It looks a design issue and hard to workaround
> > > totally, so disable dma functhion here. And will re-enable it
> > > once the root cause found.
> > > 
> > Sorry, I'm late to this as Shawn seems to already have picked up this
> > patch, but this isn't the right way to fix the problem.
> > 
> > We made it clear at kernel summit last year that we try to not break
> > existing DTs as booting a new kernel with an old DT is a valid use case.
> > While you don't strictly violate this rule what you do here is only
> > fixing systems booting with a new DT while leaving others broken.
> > 
> > If you are working around a hardware problem please disable DMA support
> > in the driver. This will also allow you to enable it again, if you find
> > another workaround without touching the DT again.
> > 
> > So this patch gets a NAK from me.
> > 

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

