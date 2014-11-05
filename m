Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaKETn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:43:28 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:50162 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaKETnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:43:25 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 5 Nov 2014 14:43:23 -0500
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
Message-ID: <20141105194323.GI24112@csclub.uwaterloo.ca>
References: <20141104170233.GB24112@csclub.uwaterloo.ca>
 <5459079D.7080703@linutronix.de>
 <20141104172117.GC24112@csclub.uwaterloo.ca>
 <20141104183315.GD24112@csclub.uwaterloo.ca>
 <20141104210315.GF24112@csclub.uwaterloo.ca>
 <20141105011506.GG24112@csclub.uwaterloo.ca>
 <5459DBB7.1090702@linutronix.de>
 <20141105153307.GN24110@csclub.uwaterloo.ca>
 <20141105162024.GH24112@csclub.uwaterloo.ca>
 <545A50BB.2020307@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <545A50BB.2020307@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 05:30:51PM +0100, Sebastian Andrzej Siewior wrote:
> On 11/05/2014 05:20 PM, Lennart Sorensen wrote:
> > On Wed, Nov 05, 2014 at 10:33:15AM -0500, Lennart Sorensen wrote:
> >> Two systems ran 16 hours each so far with no issues.  Pushed 170MB of
> >> data through the pair of serial ports on one system at 230400.
> > 
> > The console on uart3 doesn't appear to be using the dma assuming the
> > values in /sys for the dma controller and bytes transferred mean anything.
> > It does mention in dmesg that it allocated dma channels for uart3 though.
> 
> Then it should use it :)

I managed to get something dma related on uart3.  But it isn't happy:

[   95.577401] DMA misaligned error with device 53
repeated many times.

I wonder if the dma support isn't quite working for the omap572x yet in
this tree (ti's 3.12.y tree), or maybe it is picky and the driver still
needs a bit of work.

I have had no issues on uart7 and 8 without dma.

> There is omap_8250_tx_dma() and omap_8250_rx_dma(). Both setup
> callbacks (the rx+tx _complete). Upon successful DMA transfer you
> should see them invoked with bytes transfered (>0).
> For RX transfer you need at least trigger bytes in the FIFO within a
> given time frame (I think it was 46 bytes and the delay may be up to 2
> bytes). If you miss this then DMA for RX won't wire and you purge the
> FIFO manually via "timeout-interrupt" (the callback will be invoked
> with an error condition and 0 bytes).
> 
> Assuming this works for you then one should figure out why the counters
> in /sys are not updated…

-- 
Len Sorensen
