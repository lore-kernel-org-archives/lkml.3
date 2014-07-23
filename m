Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbaGWLQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:16:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:32329 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755909AbaGWLQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:16:29 -0400
Date: Wed, 23 Jul 2014 12:16:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>, David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv4 3/5] common: dma-mapping: Introduce common remapping
 functions
Message-ID: <20140723111608.GC1366@localhost>
References: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org>
 <1406079308-5232-4-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406079308-5232-4-git-send-email-lauraa@codeaurora.org>
Thread-Topic: [PATCHv4 3/5] common: dma-mapping: Introduce common remapping
 functions
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 02:35:06AM +0100, Laura Abbott wrote:
> +void dma_common_free_remap(void *cpu_addr, size_t size, unsigned long vm_flags)
> +{
> +	struct vm_struct *area = find_vm_area(cpu_addr);
> +
> +	if (!area || (area->flags & vm_flags) != vm_flags) {
> +		WARN(1, "trying to free invalid coherent area: %p\n", cpu_addr);
> +		return;
> +	}
> +
> +	unmap_kernel_range((unsigned long)cpu_addr, size);
> +	vunmap(cpu_addr);
> +}

One more thing - is unmap_kernel_range() needed here? vunmap() ends up
calling vunmap_page_range(), same as unmap_kernel_range(). I think one
difference is that in the vunmap case, TLB flushing is done lazily.

-- 
Catalin
