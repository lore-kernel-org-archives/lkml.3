Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbaJ3TnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:43:18 -0400
Received: from theshire.emacs.cl ([192.155.80.235]:36087 "EHLO
	theshire.emacs.cl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275AbaJ3TmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:42:22 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: akpm@linux-foundation.org
Cc: hughd@google.com, riel@redhat.com, mgorman@suse.de, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, dbueso@suse.de,
        linux-mm@kvack.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 01/10] mm,fs: introduce helpers around the i_mmap_mutex
Date: Thu, 30 Oct 2014 12:34:08 -0700
Message-Id: <1414697657-1678-2-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414697657-1678-1-git-send-email-dave@stgolabs.net>
References: <1414697657-1678-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various parts of the kernel acquire and release this mutex,
so add i_mmap_lock_write() and immap_unlock_write() helper
functions that will encapsulate this logic. The next patch
will make use of these.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
---
 include/linux/fs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 09d4480..f3a2372 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -467,6 +467,16 @@ struct block_device {
 
 int mapping_tagged(struct address_space *mapping, int tag);
 
+static inline void i_mmap_lock_write(struct address_space *mapping)
+{
+	mutex_lock(&mapping->i_mmap_mutex);
+}
+
+static inline void i_mmap_unlock_write(struct address_space *mapping)
+{
+	mutex_unlock(&mapping->i_mmap_mutex);
+}
+
 /*
  * Might pages of this file be mapped into userspace?
  */
-- 
1.8.4.5

