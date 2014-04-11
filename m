Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbaDKMw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:52:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:56982 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaDKMwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:52:24 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <cl@linux-foundation.org>, <penberg@kernel.org>, <gthelen@google.com>,
        <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH -mm] slab: document kmalloc_order
Date: Fri, 11 Apr 2014 16:52:16 +0400
Message-ID: <1397220736-13840-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140410163831.c76596b0f8d0bef39a42c63f@linux-foundation.org>
References: <20140410163831.c76596b0f8d0bef39a42c63f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slab_common.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index cab4c49b3e8c..3ffd2e76b5d2 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -573,6 +573,11 @@ void __init create_kmalloc_caches(unsigned long flags)
 }
 #endif /* !CONFIG_SLOB */
 
+/*
+ * To avoid unnecessary overhead, we pass through large allocation requests
+ * directly to the page allocator. We use __GFP_COMP, because we will need to
+ * know the allocation order to free the pages properly in kfree.
+ */
 void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 {
 	void *ret;
-- 
1.7.10.4

