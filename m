Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaHOTd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:33:56 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:33575 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaHOTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:33:55 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 15 Aug 2014 15:33:52 -0400
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 05/15] tty: serial: Add 8250-core based omap driver
Message-ID: <20140815193352.GC17765@csclub.uwaterloo.ca>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <1408124563-31541-6-git-send-email-bigeasy@linutronix.de>
 <20140815183731.GI17769@csclub.uwaterloo.ca>
 <53EE5F3F.2000707@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53EE5F3F.2000707@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 09:27:59PM +0200, Sebastian Andrzej Siewior wrote:
> If you want to change this to reduce the gap, then you have first
> change 8250 core code. Currently it waits until the shift register is
> empty.

Oh the 8250 normally works this way?  I didn't know that.

> On the other hand if you use DMA then it can handle transfers > 64bytes
> in one go and you can start transfers while the FIFO is not completely
> empty.

You can dma more than the fifo size?

> If you use DMA. You program one transfer says 100 bytes. You get an
> dma-transfer complete once the 100 bytes are transfered which means the
> FIFO has 63 bytes. From this point on you could enqueue the next
> transfer with say another 100 bytes. In that scenario you don't see the
> gap.
> 
> You get only to the gap if you use the non-DMA mode (and not UARTs
> support DMA). In that case, yes waiting till there only 16 bytes before
> starting the refill would make sense if you want to utilize the port by
> 100%. But as I said in 0/15, you need to teach the core this first.
> Otherwise it will return doing nothing until the shift register is
> empty (i.e. until the FIFO is completely empty).

Well if DMA takes care of it, and the normal 8250 is already like this,
then I suppose it is already better than the typical case.

> There is patch in Greg's tty tree already where you are able to
> configure the RX trigger level. We could wire this up once we agree
> which levels we want support. The OMAP supports all levels from 1…63.

All? or just every 4 (that's what I just read in the DRA7xx docs).

> Yes, true. However this is only an issue without HW control. With DMA
> the buffer is slightly larger. The DMA engine starts the transfer on
> its own once there 48 bytes in the FIFO (except in the few cases where
> it does not).

That's nice of it.  I will have to give this a try.

-- 
Len Sorensen
