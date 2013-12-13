Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3LMVhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:37:40 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:45833 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LMVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:37:38 -0500
Date: Fri, 13 Dec 2013 16:37:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 08/23] mm/memblock: Add memblock memory allocation apis
Message-ID: <20131213213735.GM27070@htj.dyndns.org>
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
 <1386625856-12942-9-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386625856-12942-9-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 04:50:41PM -0500, Santosh Shilimkar wrote:
> Introduce memblock memory allocation APIs which allow to support
> PAE or LPAE extension on 32 bits archs where the physical memory
> start address can be beyond 4GB. In such cases, existing bootmem
> APIs which operate on 32 bit addresses won't work and needs
> memblock layer which operates on 64 bit addresses.

The overall API looks good to me.  Thanks for doing this!

> +static void * __init memblock_virt_alloc_internal(
> +				phys_addr_t size, phys_addr_t align,
> +				phys_addr_t min_addr, phys_addr_t max_addr,
> +				int nid)
> +{
> +	phys_addr_t alloc;
> +	void *ptr;
> +
> +	if (nid == MAX_NUMNODES)
> +		pr_warn("%s: usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE\n",
> +			__func__);

Why not use WARN_ONCE()?  Also, shouldn't nid be set to NUMA_NO_NODE
here?

...
> +	if (nid != NUMA_NO_NODE) {

Otherwise, the above test is broken.

> +		alloc = memblock_find_in_range_node(size, align, min_addr,
> +						    max_addr,  NUMA_NO_NODE);
> +		if (alloc)
> +			goto done;
> +	}

Thanks.

-- 
tejun
