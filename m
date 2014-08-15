Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaHOSRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:17:09 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:57541 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHOSRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:17:07 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 15 Aug 2014 14:17:04 -0400
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7] 8250-core based serial driver for OMAP + DMA
Message-ID: <20140815181704.GH17769@csclub.uwaterloo.ca>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 07:42:28PM +0200, Sebastian Andrzej Siewior wrote:
> This is my complete queue fo the omap serial driver based on the 8250 core
> code. I played with it on beagle bone, am335x-evm and dra7xx including DMA.
> The uncertain remain the runtime-pm pieces.
> I hacked a small serial testing application which sent 10x 4KiB of data in
> raw mode. The number of interrupts in comparison:
> 
>     serial-omap | 8250 omap | 8250 omap + dma |
>    --------------------------------------------
> TX |       2558 |       641 |         0 +  30 |
> RX |      40960 |       854 |         1 + 853 |
> 
> So the 8250 version uses less interrupts for the same amount of data.
> The consequence is that in TX mode there should be "short" periods where
> no data is sent (before the CPU gets to re-fill the FIFO). On RX we have
> a smaller time frame where we have to start to purge the FIFO before it
> overflows.

Are you saying that with the new driver you have to respond to the RX
irq faster than before to avoid overflows?  It is not quite clear.

I do think 40000 interrupts to handle 40000 bytes of date does seem a
tad inefficient, so dropping to 854 looks a lot nicer.  Was the omap
driver not using the fifo trigger levels at all?

-- 
Len Sorensen
