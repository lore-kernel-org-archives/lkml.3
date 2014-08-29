Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbaH2VF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 17:05:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaH2VFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 17:05:23 -0400
Date: Fri, 29 Aug 2014 14:05:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-mm@kvack.org, Rafael Aquini <aquini@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] mm/balloon_compaction: general cleanup
Message-Id: <20140829140521.ca9b1dc87c8bc4b075f5b083@linux-foundation.org>
In-Reply-To: <20140820150509.4194.24336.stgit@buzz>
References: <20140820150435.4194.28003.stgit@buzz>
	<20140820150509.4194.24336.stgit@buzz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014 19:05:09 +0400 Konstantin Khlebnikov <k.khlebnikov@samsung.com> wrote:

> * move special branch for balloon migraion into migrate_pages
> * remove special mapping for balloon and its flag AS_BALLOON_MAP
> * embed struct balloon_dev_info into struct virtio_balloon
> * cleanup balloon_page_dequeue, kill balloon_page_free
> 

grump.

diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-general-cleanup-fix include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-general-cleanup-fix
+++ a/include/linux/balloon_compaction.h
@@ -145,7 +145,7 @@ static inline void
 balloon_page_insert(struct balloon_dev_info *balloon, struct page *page)
 {
 	__SetPageBalloon(page);
-	list_add(&page->lru, head);
+	list_add(&page->lru, &balloon->pages);
 }
 
 static inline void balloon_page_delete(struct page *page, bool isolated)


This obviously wasn't tested with CONFIG_BALLOON_COMPACTION=n.  Please
complete the testing of this patchset and let us know the result?

Thanks.
