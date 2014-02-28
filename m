Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaB1WT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:19:28 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61634 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaB1WTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:19:23 -0500
From: Ning Qu <quning@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ning Qu <quning@google.com>
Subject: [PATCH 1/1] mm: implement ->map_pages for shmem/tmpfs
Date: Fri, 28 Feb 2014 14:18:51 -0800
Message-Id: <1393625931-2858-2-git-send-email-quning@google.com>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
In-Reply-To: <1393625931-2858-1-git-send-email-quning@google.com>
References: <1393625931-2858-1-git-send-email-quning@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In shmem/tmpfs, we also use the generic filemap_map_pages,
seems the additional checking is not worth a separate version
of map_pages for it.

Signed-off-by: Ning Qu <quning@google.com>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1f18c9d..2ea4e89 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2783,6 +2783,7 @@ static const struct super_operations shmem_ops = {
 
 static const struct vm_operations_struct shmem_vm_ops = {
 	.fault		= shmem_fault,
+	.map_pages	= filemap_map_pages,
 #ifdef CONFIG_NUMA
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
-- 
1.9.0.279.gdc9e3eb

