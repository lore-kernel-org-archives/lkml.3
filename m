Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaKQIWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:22:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:41941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaKQIWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:22:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,401,1413270000"; 
   d="scan'208";a="638118898"
Date: Mon, 17 Nov 2014 13:53:46 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl330: Fix linker error "undefined
 reference to `__aeabi_uldivmod'"
Message-ID: <20141117082346.GQ24582@intel.com>
References: <1415896047.1787.4.camel@linaro.org>
 <20141113170104.GP24582@intel.com>
 <1415898688.1787.6.camel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415898688.1787.6.camel@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 05:11:28PM +0000, Jon Medhurst (Tixy) wrote:
> On Thu, 2014-11-13 at 22:31 +0530, Vinod Koul wrote:
> > On Thu, Nov 13, 2014 at 04:27:27PM +0000, Jon Medhurst (Tixy) wrote:
> > > 32-bit ARM kernels may have a 64-bit dma_addr_t but have no
> > > implementation of the compiler helper for 64-bit unsigned division,
> > > therefore the use of the modulo operator in pl330_prep_dma_memcpy causes
> > > the link error "undefined reference to `__aeabi_uldivmod'"
> > > 
> > > As the burst value is always a power of two we can fix the problem, and
> > > make the code more efficient, by replacing "% burst" with "& (burst-1)".
> > > 
> > > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > > Signed-off-by: Jon Medhurst <tixy@linaro.org>
> > > ---
> > > 
> > > Vinod. I haven't added a 'Fixes:' line because I was unsure if the patch
> > > in linux-next is part of a stable branch or if the SHA1 might change
> > > before hitting mainline. If it stable then the line should be...
> > > 
> > > Fixes: 63369d0a96dc ("dmaengine: pl330: Align DMA memcpy operations to MFIFO width")
> > I have applied this for now but...
> > 
> > While at it and also related to Fixes, typically the fixes branch wont be
> > rebased before its sent to Linus and merged. But this is introduced in patch
> > which is sent, should I just fold it in and not cause this regression in
> > first place...?
> 
> I have no objection to folding it in, but then doesn't that remove
> credit for Fengguang Wu's test system for finding and reporting errors?
I added entry for that and retiained credit to him.

-- 
~Vinod
