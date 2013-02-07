Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520Ab3BGX0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:26:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394Ab3BGX0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:26:11 -0500
Date: Thu, 7 Feb 2013 15:26:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, mgorman@suse.de, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] mm: accurately document nr_free_*_pages
 functions with code comments
Message-Id: <20130207152609.0dd07498.akpm@linux-foundation.org>
In-Reply-To: <51130A07.2000805@cn.fujitsu.com>
References: <5112138C.7040902@cn.fujitsu.com>
	<5112FB96.1040606@infradead.org>
	<51130A07.2000805@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2013 09:57:27 +0800
Zhang Yanfei <zhangyanfei@cn.fujitsu.com> wrote:

> Functions nr_free_zone_pages, nr_free_buffer_pages and nr_free_pagecache_pages
> are horribly badly named, so accurately document them with code comments
> in case of the misuse of them.

Looks OK.  I fiddled with it a bit:

--- a/mm/page_alloc.c~mm-accurately-document-nr_free__pages-functions-with-code-comments-fix
+++ a/mm/page_alloc.c
@@ -2813,12 +2813,12 @@ void free_pages_exact(void *virt, size_t
 EXPORT_SYMBOL(free_pages_exact);
 
 /**
- * nr_free_zone_pages - get pages that is beyond high watermark
+ * nr_free_zone_pages - count number of pages beyond high watermark
  * @offset: The zone index of the highest zone
  *
- * The function counts pages which are beyond high watermark within
- * all zones at or below a given zone index. For each zone, the
- * amount of pages is calculated as:
+ * nr_free_zone_pages() counts the number of counts pages which are beyond the
+ * high watermark within all zones at or below a given zone index.  For each
+ * zone, the number of pages is calculated as:
  *     present_pages - high_pages
  */
 static unsigned long nr_free_zone_pages(int offset)
@@ -2842,10 +2842,10 @@ static unsigned long nr_free_zone_pages(
 }
 
 /**
- * nr_free_buffer_pages - get pages that is beyond high watermark
+ * nr_free_buffer_pages - count number of pages beyond high watermark
  *
- * The function counts pages which are beyond high watermark within
- * ZONE_DMA and ZONE_NORMAL.
+ * nr_free_buffer_pages() counts the number of pages which are beyond the high
+ * watermark within ZONE_DMA and ZONE_NORMAL.
  */
 unsigned long nr_free_buffer_pages(void)
 {
@@ -2854,10 +2854,10 @@ unsigned long nr_free_buffer_pages(void)
 EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 
 /**
- * nr_free_pagecache_pages - get pages that is beyond high watermark
+ * nr_free_pagecache_pages - count number of pages beyond high watermark
  *
- * The function counts pages which are beyond high watermark within
- * all zones.
+ * nr_free_pagecache_pages() counts the number of pages which are beyond the
+ * high watermark within all zones.
  */
 unsigned long nr_free_pagecache_pages(void)
 {
_

