Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaGBUk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:40:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49823 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751535AbaGBUk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:40:28 -0400
Date: Wed, 2 Jul 2014 16:40:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Stuge <peter@stuge.se>
cc: Stefan Klug <stefan.klug@baslerweb.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
In-Reply-To: <20140702194222.11771.qmail@stuge.se>
Message-ID: <Pine.LNX.4.44L0.1407021630340.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Peter Stuge wrote:

> > The kernel doesn't support scatter-gather for control transfers, only 
> > bulk.
> 
> That could possibly change, right, and then it would be nice to have
> zerocopy for free there as well?

No.  ohci-hcd doesn't support control transfers larger than 4 KB
anyway, and ehci-hcd doesn't support control transfers larger than 16 
KB.  This is not likely to change.  Besides, a control transfer can 
never be larger than 64 KB, and throughput isn't an issue for them.

> > > Indeed I think userspace wants to be involved in choosing memory also
> > > with bulk, in order to ensure that zerocopy will always work when
> > > userspace cares about that.
> > > 
> > > Is it enough to expose the DMA mask of the host controller?
> > 
> > It doesn't need to be exposed, since the mmap(2) call would be handled
> > by the kernel's USB stack (and besides, the user program can't request
> > that the mapped memory be located in any particular physical address
> > region).
> 
> Since alignment isn't the only issue I don't think there's a way to
> avoid it. I was just hoping to be able to avoid allocating zerocopy
> buffers with mmap().

How else can you guarantee that a buffer is located in the first 4 GB
of memory?  Even on a 32-bit system (if the computer has more than 4 GB 
of RAM)?

Alan Stern

