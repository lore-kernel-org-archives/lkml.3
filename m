Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaHKJaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:30:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61848 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbaHKJay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:30:54 -0400
Date: Mon, 11 Aug 2014 10:30:24 +0100
From: Will Deacon <will.deacon@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv6 0/5] DMA Atomic pool for arm64
Message-ID: <20140811093024.GF15344@arm.com>
References: <1407529848-6806-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407529848-6806-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 09:30:48PM +0100, Laura Abbott wrote:
> Hi,
> 
> This is v6 of the series to add an atomic pool for arm64 and refactor some of
> the arm dma_atomic code as well.
> 
> Russell, assuming you have no issues I'd like to get your Acked-by before
> Catalin picks this up. As always, testing and reviews are appreiciated.
> 
> Thanks,
> Laura
> 
> 
> v6: Tweaked the commit text to clarify that arm is moving from
> ioremap_page_range to map_vm_area and friends
> 
> v5: v4: Addressed comments from Thierry and Catalin. Updated map_vm_area call in
> dma_common_pages_remap since the API changed.
> 
> v4: Simplified the logic in gen_pool_first_fit_order_align which makes the
> data argument actually unused.
> 
> v3: Now a patch series due to refactoring of arm code. arm and arm64 now both
> use genalloc for atomic pool management. genalloc extensions added.
> DMA remapping code factored out as well.
> 
> v2: Various bug fixes pointed out by David and Ritesh (CMA dependency, swapping
> coherent, noncoherent). I'm still not sure how to address the devicetree
> suggestion by Will [1][2]. I added the devicetree mailing list this time around
> to get more input on this.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/249180.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/249528.html

FWIW: I don't think the device-tree comments need to block this series. I
was just curious as to why they weren't being used.

Will
