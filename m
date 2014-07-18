Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935091AbaGROOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:14:05 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:42751 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934714AbaGROOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:14:02 -0400
Date: Fri, 18 Jul 2014 15:13:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Laura Abbott <lauraa@codeaurora.org>, Will Deacon <Will.Deacon@arm.com>,
        David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 3/5] common: dma-mapping: Introduce common remapping
 functions
Message-ID: <20140718141335.GC4608@arm.com>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
 <1404324218-4743-4-git-send-email-lauraa@codeaurora.org>
 <CAOesGMimCAYnqxkKoYpZ2ws7x9eH4K1Yw3LnLz9HC6MWyHEo3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMimCAYnqxkKoYpZ2ws7x9eH4K1Yw3LnLz9HC6MWyHEo3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 11:46:56PM +0100, Olof Johansson wrote:
> On Wed, Jul 2, 2014 at 11:03 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> > For architectures without coherent DMA, memory for DMA may
> > need to be remapped with coherent attributes. Factor out
> > the the remapping code from arm and put it in a
> > common location to reduced code duplication.
> >
> > Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> 
> Hm. The switch from ioremap to map_vm_area() here seems to imply that
> lib/ioremap can/should be reworked to use just wrap the vmalloc
> functions too?

ioremap_page_range() does not require the allocation of a map page array
and assumes that the mapped memory is physically contiguous. This would
be more efficient than the vmap() implementation which is generic enough
to allow non-contiguous memory allocations.

At some point, we'll have to support SMMU on arm64 and we can have 4
combinations of coherency and IOMMU. When an IOMMU is present, we don't
require physically contiguous memory but we may require non-cacheable
mappings, in which case vmap comes in handy.

-- 
Catalin
