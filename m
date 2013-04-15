Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3DORrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:47:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:61494 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab3DORrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:47:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,477,1363158000"; 
   d="scan'208";a="227400699"
Date: Mon, 15 Apr 2013 22:47:27 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: djbw@fb.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] ioatdma: Intel S1200 support patches
Message-ID: <20130415171727.GI12436@intel.com>
References: <20130410234230.9082.89305.stgit@djiang5-linux2.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410234230.9082.89305.stgit@djiang5-linux2.ch.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:44:14PM -0700, Dave Jiang wrote:
> These are the updated patches from first submission series and rebased against
> vinod's slave-dma git tree for-linus branch.
> 
> Patches 1 & 4 have been updated after discussion with Dan. Patch 5 was acked by
> Dan but requires additional review by Dan. I had to make additional modification
> to get raid6test working.
Applied 1, 3, 4 and v3

--
~Vinod
> 
> ---
> 
> Dave Jiang (5):
>       ioatdma: Removing hw bug workaround for CB3.x .2 and earlier
>       ioatdma: Adding support for 16 src PQ ops and super extended descriptors
>       ioatdma: S1200 platforms ioatdma channel 2 and 3 falsely advertise RAID cap
>       ioatdma: Adding write back descriptor error status support for ioatdma 3.3
>       async_tx: allow generic async_memcpy() not be effected by channel switch
> 
> 
>  crypto/async_tx/async_memcpy.c |   76 ++++--
>  drivers/dma/ioat/dma.h         |   18 +
>  drivers/dma/ioat/dma_v2.h      |    2 
>  drivers/dma/ioat/dma_v3.c      |  538 +++++++++++++++++++++++++++++++++++++---
>  drivers/dma/ioat/hw.h          |   60 ++++
>  drivers/dma/ioat/pci.c         |    3 
>  drivers/dma/ioat/registers.h   |    2 
>  drivers/md/raid5.c             |   15 +
>  include/linux/async_tx.h       |    5 
>  include/linux/dmaengine.h      |   34 ---
>  10 files changed, 647 insertions(+), 106 deletions(-)
