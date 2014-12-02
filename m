Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbaLBANE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 19:13:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaLBANB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 19:13:01 -0500
Date: Mon, 1 Dec 2014 16:13:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongbo Zhong <bocui107@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mm: Remove the highmem zones' memmap in the highmem
 zone
Message-Id: <20141201161300.8d370b30b181e988065ec71d@linux-foundation.org>
In-Reply-To: <1417085194-17042-1-git-send-email-bocui107@gmail.com>
References: <1417085194-17042-1-git-send-email-bocui107@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 18:46:34 +0800 Hongbo Zhong <bocui107@gmail.com> wrote:

> From: Zhong Hongbo <bocui107@gmail.com>
> 
> Since the commit 01cefaef40c4 ("mm: provide more accurate estimation
> of pages occupied by memmap") allocate the pages from lowmem for the
> highmem zones' memmap. So It is not need to reserver the memmap's for
> the highmem.

Looks right.

> A 2G DDR3 for the arm platform:
> On node 0 totalpages: 524288
> free_area_init_node: node 0, pgdat 80ccd380, node_mem_map 80d38000
>   DMA zone: 3568 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 456704 pages, LIFO batch:31
>   HighMem zone: 528 pages used for memmap
>   HighMem zone: 67584 pages, LIFO batch:15
> 
> On node 0 totalpages: 524288
> free_area_init_node: node 0, pgdat 80cd6f40, node_mem_map 80d42000
>   DMA zone: 3568 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 456704 pages, LIFO batch:31
>   HighMem zone: 67584 pages, LIFO batch:15

So nothing changed.  Maybe it would have if the machine had more
highmem.

I'm trying to work out what effect this patch actually has.  AFAICT it
provides more accurate values for zone->min_unmapped_pages and
zone->min_slab_pages on NUMA.  Anything else?


