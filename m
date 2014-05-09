Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbaEIWDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 18:03:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbaEIWDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 18:03:33 -0400
Date: Fri, 9 May 2014 15:03:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v4 4/6] mm, compaction: embed migration mode in
 compact_control
Message-Id: <20140509150331.55f9b8b17c720baafa408e8f@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1405070336200.16568@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1405061921420.18635@chino.kir.corp.google.com>
	<536A030D.4070407@suse.cz>
	<alpine.DEB.2.02.1405070336200.16568@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 03:36:46 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> We're going to want to manipulate the migration mode for compaction in the page 
> allocator, and currently compact_control's sync field is only a bool.  
> 
> Currently, we only do MIGRATE_ASYNC or MIGRATE_SYNC_LIGHT compaction depending 
> on the value of this bool.  Convert the bool to enum migrate_mode and pass the 
> migration mode in directly.  Later, we'll want to avoid MIGRATE_SYNC_LIGHT for 
> thp allocations in the pagefault patch to avoid unnecessary latency.
> 
> This also alters compaction triggered from sysfs, either for the entire system 
> or for a node, to force MIGRATE_SYNC.

mm/page_alloc.c: In function 'alloc_contig_range':
mm/page_alloc.c:6255: error: unknown field 'sync' specified in initializer

--- a/mm/page_alloc.c~mm-compaction-embed-migration-mode-in-compact_control-fix
+++ a/mm/page_alloc.c
@@ -6252,7 +6252,7 @@ int alloc_contig_range(unsigned long sta
 		.nr_migratepages = 0,
 		.order = -1,
 		.zone = page_zone(pfn_to_page(start)),
-		.sync = MIGRATE_SYNC_LIGHT,
+		.mode = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);


Please check that you sent the correct version of this?
