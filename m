Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaAPWnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:43:18 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43617 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaAPWnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:43:15 -0500
Date: Thu, 16 Jan 2014 14:43:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org,
        liuj97@gmail.com, santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        iamjoonsoo.kim@lge.com, robin.m.holt@gmail.com, yinghai@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/nobootmem: Fix unused variable
In-Reply-To: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1401161438240.31228@chino.kir.corp.google.com>
References: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Philipp Hachtmann wrote:

> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index e2906a5..12cbb04 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -116,9 +116,13 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
>  static unsigned long __init free_low_memory_core_early(void)
>  {
>  	unsigned long count = 0;
> -	phys_addr_t start, end, size;
> +	phys_addr_t start, end;
>  	u64 i;
>  
> +#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
> +	phys_addr_t size;
> +#endif
> +
>  	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
>  		count += __free_memory_core(start, end);
>  

Two options: (1) add a helper function declared for 
CONFIG_ARCH_DISCARD_MEMBLOCK that returns the count to add and is empty 
otherwise, or (2) initialize size to zero in its definition.  It's much 
better than #ifdef's inside the function for a variable declaration.

Also, since this is already in -mm, you'll want this fix folded into the 
original patch, "mm/nobootmem: free_all_bootmem again", so it's probably 
best to name it "mm/nobootmem: free_all_bootmem again fix".
