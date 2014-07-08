Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaGHQqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:46:39 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46460 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaGHQqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:46:36 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrew Morton <akpm@linux-foundation.org>, Gioh Kim <gioh.kim@lge.com>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonsoo Kim <js1304@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        Gi-Oh Kim <gurugio@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
In-Reply-To: <20140707155252.15e81dff6683393ba3590478@linux-foundation.org>
Organization: http://mina86.com/
References: <53B664E5.5060102@lge.com> <20140707155252.15e81dff6683393ba3590478@linux-foundation.org>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140708:gunho.lee@lge.com::YlaRKbtKO3KfM/S+:000000000000000000000000000000000000000000000iEG
X-Hashcash: 1:20:140708:m.szyprowski@samsung.com::ID7cziSw8/UX7QMZ:00000000000000000000000000000000000000bFH
X-Hashcash: 1:20:140708:gurugio@gmail.com::06pVPZKrfd/Hv5OP:0000000000000000000000000000000000000000000019jx
X-Hashcash: 1:20:140708:linux-fsdevel@vger.kernel.org::vQw74JSs6ATA8VWy:000000000000000000000000000000001XFl
X-Hashcash: 1:20:140708:lauraa@codeaurora.org::PpXlBFOLGM8FfdVS:00000000000000000000000000000000000000002Ntf
X-Hashcash: 1:20:140708:gioh.kim@lge.com::S7UPSnyYnzx5q0lj:0376R
X-Hashcash: 1:20:140708:m.szyprowski@samsung.com::e8i1L+cUWhchu7CE:00000000000000000000000000000000000003Yel
X-Hashcash: 1:20:140708:viro@zeniv.linux.org.uk::/KYtite2NDkv59kG:000000000000000000000000000000000000004VaD
X-Hashcash: 1:20:140708:akpm@linux-foundation.org::VZBKiFdLVkSc6z1+:00000000000000000000000000000000000078cm
X-Hashcash: 1:20:140708:js1304@gmail.com::vqsxKzN7/fsu0bFD:0BRyG
X-Hashcash: 1:20:140708:linux-kernel@vger.kernel.org::0qpahM7rI62IDaMI:000000000000000000000000000000000LL8c
Date: Tue, 08 Jul 2014 18:46:31 +0200
Message-ID: <xa1tpphf4x3s.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07 2014, Andrew Morton <akpm@linux-foundation.org> wrote:
> What I proposed is that CMA call invalidate_bh_lrus() right at the
> outset.  Something along the lines of
>
> --- a/mm/page_alloc.c~a
> +++ a/mm/page_alloc.c
> @@ -6329,6 +6329,14 @@ int alloc_contig_range(unsigned long sta
>  	};
>  	INIT_LIST_HEAD(&cc.migratepages);
>  
> +#ifdef CONFIG_CMA
> +	/*
> +	 * Comment goes here
> +	 */
> +	if (migratetype == MIGRATE_CMA)
> +		invalidate_bh_lrus();
> +#endif
> +

This seems reasonable, except I think it should go after
start_isolate_page_range call because otherwise there's no guarantee
that someone won't grab those pages back.

Also to avoid the #ifdef perhaps we want this as well:

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6cbd1b6..2640a55 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -64,10 +64,11 @@ enum {
 };
 
 #ifdef CONFIG_CMA
-#  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
+#  define __is_migrate_cma(migratetype) ((migratetype) == MIGRATE_CMA)
 #else
-#  define is_migrate_cma(migratetype) false
+#  define __is_migrate_cma(migratetype) false
 #endif
+#define is_migrate_cma(migratetype) unlikely(__is_migrate_cma(migratetype))
 
 #define for_each_migratetype_order(order, type) \
 	for (order = 0; order < MAX_ORDER; order++) \

and then use “if (__is_migrate_cma(migratetype))”.

>  	/*
>  	 * What we do here is we mark all pageblocks in range as
>  	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
>
>
> - I'd have thought that it would make sense to do this for huge pages
>   as well (MIGRATE_MOVABLE) but nobody really seems to know.
>
> - There's a patch floating around ("Allow increasing the buffer-head
>   per-CPU LRU size") which will double the size of the bh lrus, so this
>   all becomes more important.
>
> - alloc_contig_range() does lru_add_drain_all() and drain_all_pages()
>   *after* performing the allocation.  I can't work out why this is the
>   case and of course it is undocumented.  If this is indeed not a bug
>   then probably the invalidate_bh_lrus() should happen in the same
>   place.

The purpose is to get free non-buddy pages (so pages on PCP lists for
instance) back onto the buddy list.  It's safe to move those calls above
the call to __alloc_contig_migrate_range, but I don't think it will
change anything (except of course the fact that if migration fails,
we'll do the draining for nothing).

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
