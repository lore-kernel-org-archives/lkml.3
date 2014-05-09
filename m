Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbaEIQhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:37:16 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:62345 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbaEIQhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:37:14 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 9 May 2014 18:36:52 +0200
From: Johan Hovold <johan@hovold.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Johan Hovold <johan@hovold.com>, Bryan Evenson <bevenson@melinkcorp.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
Message-ID: <20140509163652.GE6776@localhost>
References: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com>
 <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140508154912.GA6776@localhost>
 <536BBEA4.6080908@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536BBEA4.6080908@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 07:28:04PM +0200, Boris BREZILLON wrote:

> > You should also keep the flush (read of IMR) regardless (to make sure
> > the write has reached the peripheral), and remember to remove the now
> > unused mask variable.
> 
> Does it has something to do with memory barriers ?
> If so, why not using writel instead of writel_relaxed ?

You only need to use the non-relaxed version when synchronising with DMA
operations.

The read-back of a register on the same device is a common technique to
make sure that preceding write has actually reached the peripheral
(write posting or flushing). In this case, it is used to make
(reasonably) sure that interrupts have actually been masked before
returning. (In the general case, you'd even need to verify the read-back
value to be certain that the device has changed its state.)

Johan
