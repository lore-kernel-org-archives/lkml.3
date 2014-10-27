Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaJ0QZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:25:08 -0400
Received: from 8bytes.org ([81.169.241.247]:34457 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbaJ0QZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:25:05 -0400
Date: Mon, 27 Oct 2014 17:25:02 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, sebott@linux.vnet.ibm.com
Subject: Re: [PATCH linux-next] iommu: add iommu for s390 platform
Message-ID: <20141027162502.GB6202@8bytes.org>
References: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com>
 <20141022141728.GG10074@8bytes.org>
 <20141022154320.GA42442@tuxmaker.boeblingen.de.ibm.com>
 <20141023124115.GB10053@8bytes.org>
 <20141023140437.GA31009@tuxmaker.boeblingen.de.ibm.com>
 <20141027153201.517f4ff4@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027153201.517f4ff4@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 03:32:01PM +0100, Gerald Schaefer wrote:
> Not sure if I understood the concept of IOMMU domains right. But if this
> is about having multiple devices in the same domain, so that iommu_ops->map
> will establish the _same_ DMA mapping on _all_ registered devices, then
> this should be possible.

Yes, this is what domains are about. A domain describes a set of DMA
mappings which can be assigned to multiple devices in parallel.

> We cannot have shared DMA tables because each device gets its own DMA table
> allocated during device initialization.

Is there some hardware reason for this or is that just an implementation
detail that can be changed. In other words, does the hardware allow to
use the same DMA table for multiple devices?

> But we could just keep all devices from one domain in a list and then
> call dma_update_trans() for all devices during iommu_ops->map/unmap.

This sounds complicated. Note that a device can be assigned to a domain that
already has existing mappings. In this case you need to make sure that
the new device inherits these mappings (and destroy all old mappings for
the device that possibly exist).

I think it is much easier to use the same DMA table for all devices in a
domain, if the hardware allows that.


	Joerg

