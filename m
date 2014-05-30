Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaE3MKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:10:06 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:52029 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaE3MKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:10:04 -0400
Date: Fri, 30 May 2014 14:09:36 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johan Hovold <johan@hovold.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Bryan Evenson <bevenson@melinkcorp.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
Message-ID: <20140530120936.GB2044@localhost>
References: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com>
 <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140508154912.GA6776@localhost>
 <536BBEA4.6080908@free-electrons.com>
 <20140509163652.GE6776@localhost>
 <20140529160948.a63fa268a37d985189837a85@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529160948.a63fa268a37d985189837a85@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 04:09:48PM -0700, Andrew Morton wrote:
> On Fri, 9 May 2014 18:36:52 +0200 Johan Hovold <johan@hovold.com> wrote:
> 
> > On Thu, May 08, 2014 at 07:28:04PM +0200, Boris BREZILLON wrote:
> > 
> > > > You should also keep the flush (read of IMR) regardless (to make sure
> > > > the write has reached the peripheral), and remember to remove the now
> > > > unused mask variable.
> > > 
> > > Does it has something to do with memory barriers ?
> > > If so, why not using writel instead of writel_relaxed ?
> > 
> > You only need to use the non-relaxed version when synchronising with DMA
> > operations.
> > 
> > The read-back of a register on the same device is a common technique to
> > make sure that preceding write has actually reached the peripheral
> > (write posting or flushing). In this case, it is used to make
> > (reasonably) sure that interrupts have actually been masked before
> > returning. (In the general case, you'd even need to verify the read-back
> > value to be certain that the device has changed its state.)
> 
> So I grabbed this patch as it's tied to "rtc: rtc-at91rm9200: fix
> uninterruptible wait for ACKUPD" and is not in linux-next.  Someone
> shout at me if that was a mistake.

The patch is needed, but it seems you got the wrong version. There was
an updated v4 posted the next day in this thread:

	http://marc.info/?l=linux-kernel&m=139964712229420&w=2

Johan
