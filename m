Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaHaLgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:36:21 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:53007 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaHaLgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:36:20 -0400
MIME-Version: 1.0
In-Reply-To: <54012D74.7010302@infradead.org>
References: <5400fba1.732YclygYZprDXeI%akpm@linux-foundation.org>
	<54012D74.7010302@infradead.org>
Date: Sun, 31 Aug 2014 15:36:18 +0400
Message-ID: <CAPAsAGz4458YgHN0b04Z4fTwvo-guh+ESNAXy7j=c-bc7v4gcA@mail.gmail.com>
Subject: Re: [PATCH -mmotm] mm: fix kmemcheck.c build errors
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz,
        Pekka Enberg <penberg@kernel.org>, Vegard Nossum <vegardno@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-30 5:48 GMT+04:00 Randy Dunlap <rdunlap@infradead.org>:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Add header file to fix kmemcheck.c build errors:
>
> ../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
> ../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
> ../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
> ../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  mm/kmemcheck.c |    1 +
>  1 file changed, 1 insertion(+)
>
> Index: mmotm-2014-0829-1515/mm/kmemcheck.c
> ===================================================================
> --- mmotm-2014-0829-1515.orig/mm/kmemcheck.c
> +++ mmotm-2014-0829-1515/mm/kmemcheck.c
> @@ -2,6 +2,7 @@
>  #include <linux/mm_types.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
> +#include <linux/slab_def.h>

This will work only for CONFIG_SLAB=y. struct kmem_cache definition
was moved to internal header [*],
so you need to include it here:
#include "slab.h"

[*] http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header.patch

>  #include <linux/kmemcheck.h>
>
>  void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
>


-- 
Best regards,
Andrey Ryabinin
