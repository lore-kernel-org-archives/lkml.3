Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3GJVcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:32:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41143 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755310Ab3GJVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:31:59 -0400
Date: Wed, 10 Jul 2013 17:31:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: USB host support should depend on HAS_DMA
In-Reply-To: <1373491112-15593-1-git-send-email-geert@linux-m68k.org>
Message-ID: <Pine.LNX.4.44L0.1307101724430.1215-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Geert Uytterhoeven wrote:

> If NO_DMA=y:
> 
> drivers/built-in.o: In function `usb_hcd_unmap_urb_setup_for_dma':
> drivers/usb/core/hcd.c:1361: undefined reference to `dma_unmap_single'

> ,,,
> 
> Commit d9ea21a779278da06d0cbe989594bf542ed213d7 ("usb: host: make
> USB_ARCH_HAS_?HCI obsolete") allowed to enable USB on platforms with
> NO_DMA=y, and exposed several input and media USB drivers that just select
> USB if USB_ARCH_HAS_HCD, without checking HAS_DMA.
> 
> Fix the former by making USB depend on HAS_DMA.

This isn't right.  There are USB host controllers that use PIO, not
DMA.  The HAS_DMA dependency should go with the controller driver, not 
the USB core.

On the other hand, the USB core does call various routines like 
dma_unmap_single.  It ought to be possible to compile these calls even 
when DMA isn't enabled.  That is, they should be defined as do-nothing 
stubs.

> To fix the latter, instead of adding lots of "depends on HAS_DMA", make
> those drivers depend on USB, instead of depending on USB_ARCH_HAS_HCD and
> selecting USB.  Drivers for other busses (e.g. MOUSE_SYNAPTICS_I2C) already
> handle this in a similar way.

That seems reasonable.

Alan Stern

