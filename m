Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaJXWJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:09:33 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:39225 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754982AbaJXWGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:06:46 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: akpm@linux-foundation.org
Cc: hughd@google.com, riel@redhat.com, mgorman@suse.de, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, dbueso@suse.de,
        linux-mm@kvack.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 01/10] mm,fs: introduce helpers around the i_mmap_mutex
Date: Fri, 24 Oct 2014 15:06:11 -0700
Message-Id: <1414188380-17376-2-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
References: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various parts of the kernel acquire and release this mutex,
so add i_mmap_lock_write() and immap_unlock_write() helper
functions that will encapsulate this logic. The next patch
will make use of these.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 include/linux/fs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a957d43..042d5c6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -454,6 +454,16 @@ struct block_device {
 
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

