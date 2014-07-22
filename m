Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaGVQEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:04:43 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56184 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752205AbaGVQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:04:41 -0400
Date: Tue, 22 Jul 2014 17:04:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>, David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 3/5] common: dma-mapping: Introduce common remapping
 functions
Message-ID: <20140722160408.GM2219@arm.com>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
 <1404324218-4743-4-git-send-email-lauraa@codeaurora.org>
 <20140718135349.GB4608@arm.com>
 <53CD6B1C.2010801@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CD6B1C.2010801@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 08:33:48PM +0100, Laura Abbott wrote:
> On 7/18/2014 6:53 AM, Catalin Marinas wrote:
> > On Wed, Jul 02, 2014 at 07:03:36PM +0100, Laura Abbott wrote:
> >> +void *dma_common_pages_remap(struct page **pages, size_t size,
> >> +			unsigned long vm_flags, pgprot_t prot,
> >> +			const void *caller)
> >> +{
> >> +	struct vm_struct *area;
> >> +
> >> +	area = get_vm_area_caller(size, vm_flags, caller);
> >> +	if (!area)
> >> +		return NULL;
> >> +
> >> +	if (map_vm_area(area, prot, &pages)) {
> >> +		vunmap(area->addr);
> >> +		return NULL;
> >> +	}
> >> +
> >> +	return area->addr;
> >> +}
> > 
> > Why not just replace this function with vmap()? It is nearly identical.
> 
> With this version, the caller stored and printed via /proc/vmallocinfo
> is the actual caller of the DMA API whereas if we just call vmap we
> don't get any useful caller information. Going to vmap would change
> the existing behavior on ARM so it seems unwise to switch.

OK.

> Another option is to move this into vmalloc.c and add vmap_caller.

Maybe as a subsequent clean-up (once this series gets merged).

-- 
Catalin
