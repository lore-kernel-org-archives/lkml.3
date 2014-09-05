Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaIEUBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:01:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaIEUBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:01:03 -0400
Date: Fri, 5 Sep 2014 13:01:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        Pekka Enberg <penberg@kernel.org>, Vegard Nossum <vegardno@ifi.uio.no>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH -mmotm] mm: fix kmemcheck.c build errors
Message-Id: <20140905130102.f6b8866115f83a0bacedb899@linux-foundation.org>
In-Reply-To: <1409902086-32311-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1409902086-32311-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Sep 2014 16:28:06 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
> in mmotm makes following build failure.
> 
> ../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
> ../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
> ../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
> ../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type
> 
> ../mm/slab.h: In function 'cache_from_obj':
> ../mm/slab.h:283:2: error: implicit declaration of function
> 'memcg_kmem_enabled' [-Werror=implicit-function-declaration]
> 
> Add header files to fix kmemcheck.c build errors.
> 
> [iamjoonsoo.kim@lge.com] move up memcontrol.h header
> to fix build failure if CONFIG_MEMCG_KMEM=y too.

Looking at this line

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

and at this line

> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

I am suspecting that this patch was authored by Randy.  But there was
no From: line at start-of-changelog to communicate this?

> diff --git a/mm/slab.h b/mm/slab.h
> index 13845d0..963a3f8 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -37,6 +37,8 @@ struct kmem_cache {
>  #include <linux/slub_def.h>
>  #endif
>  
> +#include <linux/memcontrol.h>
> +
>  /*
>   * State of the slab allocator.
>   *

It seems a bit wrong to include a fairly high-level memcontol.h into a
fairly low-level slab.h, but I expect it will work.

I can't really see how
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
caused the breakage.  I don't know how you were triggering this build
failure - please always include such info in the changelogs.

