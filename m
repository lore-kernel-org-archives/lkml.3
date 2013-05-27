Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3E0US2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 16:18:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42111 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756959Ab3E0US1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 16:18:27 -0400
Date: Mon, 27 May 2013 16:18:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] dma-unmap: allow to only unmap completed DMA
 buffer
In-Reply-To: <1369671187-24430-1-git-send-email-ming.lei@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1305271614570.26364-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013, Ming Lei wrote:

> This patchset tries to loose the check on DMA buffer size in check_unmap()
> of dma-debug first, then only unmap the actual completed DMA buffer in USB
> unmap path.
> 
> Considered that DMA unmapping often runs in hard irq context, the patch set
> may save irq handling time. And the improvement can be observed on
> ARMv7(Pandaboard) with the chage, at average ~25us is saved about ehci irq
> handling under usbnet ping test case.

Are you aware that these changes directly contradict the advice in 
Documentation/DMA-API.txt?  That file says:


void
dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
                 enum dma_data_direction direction)

Unmaps the region previously mapped.  All the parameters passed in
must be identical to those passed in (and returned) by the mapping
API.


If you are going to make a change like this then you have to change the 
documentation too.  But in fact I doubt that the proposed change will 
work correctly in all circumstances.  For example, if an IOMMU is 
present.

Alan Stern

