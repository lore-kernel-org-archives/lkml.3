Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab3EIOky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3EIOkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:40:53 -0400
Message-ID: <518BB4F2.2040704@redhat.com>
Date: Thu, 09 May 2013 10:38:42 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: mhocko@suse.cz, akpm@linux-foundation.org, mgorman@suse.de,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] COMPACTION: bugfix of improper cache flush in MIGRATION
 code.
References: <20130509001821.15951.98705.stgit@linux-yegoshin>
In-Reply-To: <20130509001821.15951.98705.stgit@linux-yegoshin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 08:18 PM, Leonid Yegoshin wrote:
> Page 'new' during MIGRATION can't be flushed by flush_cache_page().
> Using flush_cache_page(vma, addr, pfn) is justified only if
> page is already placed in process page table, and that is done right
> after flush_cache_page(). But without it the arch function has
> no knowledge of process PTE and does nothing.
>
> Besides that, flush_cache_page() flushes an application cache,
> kernel has a different page virtual address and dirtied it.
>
> Replace it with flush_dcache_page(new) which is a proper usage.
>
> Old page is flushed in try_to_unmap_one() before MIGRATION.
>
> This bug takes place in Sead3 board with M14Kc MIPS CPU without
> cache aliasing (but Harvard arch - separate I and D cache)
> in tight memory environment (128MB) each 1-3days on SOAK test.
> It fails in cc1 during kernel build (SIGILL, SIGBUS, SIGSEG) if
> CONFIG_COMPACTION is switched ON.

Good catch!

> Author: Leonid Yegoshin <yegoshin@mips.com>
> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>

Acked-by: Rik van Riel <riel@redhat.com>

