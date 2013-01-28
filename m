Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3A1JXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:23:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:60169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931Ab3A1JXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:23:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,550,1355126400"; 
   d="scan'208";a="282975105"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 01/16] block: implement add_bdi_stat()
Date: Mon, 28 Jan 2013 11:24:13 +0200
Message-Id: <1359365068-10147-2-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

It's required for batched stats update.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/backing-dev.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3504599..b05d961 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -167,6 +167,16 @@ static inline void __dec_bdi_stat(struct backing_dev_info *bdi,
 	__add_bdi_stat(bdi, item, -1);
 }
 
+static inline void add_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item, s64 amount)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__add_bdi_stat(bdi, item, amount);
+	local_irq_restore(flags);
+}
+
 static inline void dec_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item)
 {
-- 
1.7.10.4

