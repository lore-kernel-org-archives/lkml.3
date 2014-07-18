Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030808AbaGRNyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:54:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43446 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030649AbaGRNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:54:11 -0400
Date: Fri, 18 Jul 2014 14:53:49 +0100
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
Message-ID: <20140718135349.GB4608@arm.com>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
 <1404324218-4743-4-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404324218-4743-4-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 07:03:36PM +0100, Laura Abbott wrote:
> +void *dma_common_pages_remap(struct page **pages, size_t size,
> +			unsigned long vm_flags, pgprot_t prot,
> +			const void *caller)
> +{
> +	struct vm_struct *area;
> +
> +	area = get_vm_area_caller(size, vm_flags, caller);
> +	if (!area)
> +		return NULL;
> +
> +	if (map_vm_area(area, prot, &pages)) {
> +		vunmap(area->addr);
> +		return NULL;
> +	}
> +
> +	return area->addr;
> +}

Why not just replace this function with vmap()? It is nearly identical.

-- 
Catalin
