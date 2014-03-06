Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaCFHU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:20:28 -0500
Received: from g2t2353.austin.hp.com ([15.217.128.52]:3091 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaCFHU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:20:27 -0500
Message-ID: <1394090420.2548.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
From: Davidlohr Bueso <davidlohr@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Date: Wed, 05 Mar 2014 23:20:20 -0800
In-Reply-To: <20140306180852.b1515db3cccc1622172524c0@canb.auug.org.au>
References: <20140306180852.b1515db3cccc1622172524c0@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 18:08 +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> In file included from include/linux/vmacache.h:4:0,
>                  from include/linux/sched.h:28,
>                  from arch/arm/include/asm/tlbflush.h:204,
>                  from arch/arm/include/asm/pgtable.h:28,
>                  from arch/arm/include/asm/idmap.h:5,
>                  from arch/arm/mm/idmap.c:6:
> include/linux/mm.h: In function 'is_vmalloc_addr':
> include/linux/mm.h:359:17: error: 'VMALLOC_START' undeclared (first use in this function)
> include/linux/mm.h:359:41: error: 'VMALLOC_END' undeclared (first use in this function)
> include/linux/mm.h: In function 'maybe_mkwrite':
> include/linux/mm.h:589:3: error: implicit declaration of function 'pte_mkwrite' [-Werror=implicit-function-declaration]
> In file included from include/linux/vmacache.h:4:0,
>                  from include/linux/sched.h:28,
>                  from arch/arm/include/asm/tlbflush.h:204,
>                  from arch/arm/include/asm/pgtable.h:28,
>                  from arch/arm/include/asm/idmap.h:5,
>                  from arch/arm/mm/idmap.c:6:
> include/linux/mm.h: In function 'pmd_alloc':
> include/linux/mm.h:1396:2: error: implicit declaration of function 'pud_none' [-Werror=implicit-function-declaration]
> include/linux/mm.h:1397:3: error: implicit declaration of function 'pmd_offset' [-Werror=implicit-function-declaration]
> include/linux/mm.h:1397:7: warning: pointer/integer type mismatch in conditional expression [enabled by default]
> include/linux/mm.h: In function 'pte_lockptr':
> include/linux/mm.h:1433:2: error: implicit declaration of function 'pmd_page' [-Werror=implicit-function-declaration]
> include/linux/mm.h:1433:2: warning: passing argument 1 of 'ptlock_ptr' makes pointer from integer without a cast [enabled by default]
> include/linux/mm.h:1425:27: note: expected 'struct page *' but argument is of type 'int'
> include/linux/mm.h: In function 'pgtable_init':
> include/linux/mm.h:1476:2: error: implicit declaration of function 'pgtable_cache_init' [-Werror=implicit-function-declaration]
> In file included from arch/arm/include/asm/pgtable.h:33:0,
>                  from arch/arm/include/asm/idmap.h:5,
>                  from arch/arm/mm/idmap.c:6:
> arch/arm/include/asm/pgtable-2level.h: At top level:
> arch/arm/include/asm/pgtable-2level.h:159:22: error: conflicting types for 'pmd_offset'
> include/linux/mm.h:1397:9: note: previous implicit declaration of 'pmd_offset' was here
> In file included from arch/arm/include/asm/idmap.h:5:0,
>                  from arch/arm/mm/idmap.c:6:
> arch/arm/include/asm/pgtable.h:255:1: error: conflicting types for 'pte_mkwrite'
> include/linux/mm.h:589:9: note: previous implicit declaration of 'pte_mkwrite' was here
> 
> and on and on ...
> 
> Caused by commit 0d9ad4220e6d ("mm: per-thread vma caching") which adds
> the include of linux/vmacache.h (which includes linux/mm.h) into
> linux/sched.h ... There is a reason that we did not include linux/mm.h
> into sched.h.

Apologies, I was not aware of the "no mm.h in sched.h" rule. It broke
builds on several archs.

Thanks for looking into this.

