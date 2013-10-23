Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3JWLZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:25:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44320 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab3JWLZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:25:42 -0400
Date: Wed, 23 Oct 2013 12:25:39 +0100
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] rsxx: Two important bug fixes for the rsxx block
 driver.
Message-ID: <20131023112539.GZ14598@kernel.dk>
References: <20131018220941.GA1278@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018220941.GA1278@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18 2013, Philip J. Kelleher wrote:
> The incoming patches are for the rsxx driver (drivers/block/rsxx)
> 
> Patch1:
> This patch fixes a bug in which discards were always
> calling pci_unmap_page. Discards should never call the
> pci_unmap_page function call because they are never mapped.
> 
> This caused a race condition on PowerPC systems when issuing
> discards, writes, and reads all at the same time. The
> pci_map_page function would eventually map logical address
> 0 for a read or write. Discards are always assigned a DMA
> address of 0 because they are never mapped. So if
> pci_map_page mapped address 0 for a DMA and a discard was
> "unmapped" then the address would be freed and would cause 
> an EEH event to occur when Hardware accesses the address.
> 
> This was injected/uncovered in commit:
> b347f9cf0bc8d42ee95ba1d3837fd93045ab336b
> 
> The pci_dma_mapping_error function declares -1 a DMA_ERROR
> not 0 like initially thought.
> 
> This patch should fall on top of commit id:
> fc1967bb08a6184ed44ef990e1dd4389901b809c
> 
> 
> Patch2:
> This patch fixes a possible Kernel Panic on driver load if 
> the configuration on the card is messed up or not yet set.
> The driver could possible give a 32 bit unsigned all Fs to
> the kernel as the device's block size.
> 
> Now we only write the block size to the kernel if the
> configuration from the card is valid.

Applied both for 3.13. Please stop putting that ----- line at the end of
your patches. It goes into the git commit messages and just makes
everything look ugly, I have to fix those up manually.

-- 
Jens Axboe

