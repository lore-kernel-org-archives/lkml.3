Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbaBUPoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:44:09 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36397 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaBUPoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:44:06 -0500
Date: Fri, 21 Feb 2014 15:43:54 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Grant Edwards <grant.b.edwards@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: locking changes in tty broke low latency feature
Message-ID: <20140221154354.5b1d8969@alan.etchedpixels.co.uk>
In-Reply-To: <le5uot$si0$1@ger.gmane.org>
References: <peter@hurleysoftware.com>
	<20140220215541.7D694406062@ip-64-139-1-69.sjc.megapath.net>
	<le5uot$si0$1@ger.gmane.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Back in the old days, when a serial driver pushed characters up to the
> tty layer it didn't immediately wake up a process that was blocking on
> a read().  AFAICT, that didn't happen until the next system tick. I'm
> not sure if that was just because the scheduler wasn't called until a
> tick happened, or if there was some intermediate tty-layer
> worker-thread that had to run.

Historically the interrupt handler tried to get out of the interrupt as
fast as possible and to do the minimum instruction count, because a 56K
modem on a 486 with a typical 16450A UART was *tight* and also a use case
everyone cared about.

So historically the code worked on the basis that there were two buffers
per tty. Each timer tick the kernel flipped the buffers over (hence the
legancy flip naming here and thre), and processed the data.

We do need low latency to the drivers, for FIFO setting, DMA watermarks
and for some USB dongles for configuring the packetising

Alan
