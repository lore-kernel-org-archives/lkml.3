Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbaKMRLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:11:33 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:51648 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933132AbaKMRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:11:32 -0500
Message-ID: <1415898688.1787.6.camel@linaro.org>
Subject: Re: [PATCH] dmaengine: pl330: Fix linker error "undefined reference
 to `__aeabi_uldivmod'"
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Nov 2014 17:11:28 +0000
In-Reply-To: <20141113170104.GP24582@intel.com>
References: <1415896047.1787.4.camel@linaro.org>
	 <20141113170104.GP24582@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 22:31 +0530, Vinod Koul wrote:
> On Thu, Nov 13, 2014 at 04:27:27PM +0000, Jon Medhurst (Tixy) wrote:
> > 32-bit ARM kernels may have a 64-bit dma_addr_t but have no
> > implementation of the compiler helper for 64-bit unsigned division,
> > therefore the use of the modulo operator in pl330_prep_dma_memcpy causes
> > the link error "undefined reference to `__aeabi_uldivmod'"
> > 
> > As the burst value is always a power of two we can fix the problem, and
> > make the code more efficient, by replacing "% burst" with "& (burst-1)".
> > 
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Jon Medhurst <tixy@linaro.org>
> > ---
> > 
> > Vinod. I haven't added a 'Fixes:' line because I was unsure if the patch
> > in linux-next is part of a stable branch or if the SHA1 might change
> > before hitting mainline. If it stable then the line should be...
> > 
> > Fixes: 63369d0a96dc ("dmaengine: pl330: Align DMA memcpy operations to MFIFO width")
> I have applied this for now but...
> 
> While at it and also related to Fixes, typically the fixes branch wont be
> rebased before its sent to Linus and merged. But this is introduced in patch
> which is sent, should I just fold it in and not cause this regression in
> first place...?

I have no objection to folding it in, but then doesn't that remove
credit for Fengguang Wu's test system for finding and reporting errors?

-- 
Tixy



