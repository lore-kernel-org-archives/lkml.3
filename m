Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbaGDSNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 14:13:21 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:42812 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaGDSNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 14:13:19 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 4 Jul 2014 14:13:17 -0400
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140704181317.GE17769@csclub.uwaterloo.ca>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140703184808.GD17769@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703184808.GD17769@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 02:48:08PM -0400, Lennart Sorensen wrote:
> On Wed, Jul 02, 2014 at 06:00:09PM +0200, Sebastian Andrzej Siewior wrote:
> > This patch provides a 8250-core based UART driver for the internal OMAP
> > UART. The longterm goal is to provide the same functionality as the
> > current OMAP uart driver and hopefully DMA support which could borrowed
> > from the 8250-core.
> 
> This sounds interesting.  We are currently finding the omap serial driver
> awefully slow at handling serial traffic with ti's 3.12.y kernel branch,
> while the 3.8.y was seemingly a bit better (on the dra7xx eval board).
> Haven't had time to really investigate that yet though.
> 
> > The whole PM-Runtime part is currently missing.
> > It has been only tested as console UART.
> > The tty name is ttyS based instead of ttyO. How big is the pain here,
> > what could be the easiest way to provide compatibility?
> 
> I would certainly love to see ttyS instead of ttyO.  But of course I am
> working on a new system that isn't released yet so changing things is
> a complete non issue for me. :)
> 
> I should give this driver a try and see how it compares so far.

I get a segfault at this line:

mvr = uart_read(up, UART_OMAP_MVER);

I added it to ti's 3.12.y kernel and ran it on uart7 and uart8 on
a dra7xx-evm as a module (built in the kernel never booted due to
the crash).

-- 
Len Sorensen
