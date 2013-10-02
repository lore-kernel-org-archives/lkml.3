Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3JBUSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:18:09 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:8830 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3JBUSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:18:05 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 1/2] mm,fs: introduce helpers around i_mmap_mutex
Date: Wed,  2 Oct 2013 13:17:45 -0700
Message-Id: <1380745066-9925-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380745066-9925-1-git-send-email-davidlohr@hp.com>
References: <1380745066-9925-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various parts of the kernel acquire and release this mutex,
so add i_mmap_lock_write() and immap_unlock_write() helper
functions that will encapsulate this logic. The next patch
will make use of these.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/linux/fs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3f40547..b32e64f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -478,6 +478,16 @@ struct block_device {
 
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
1.8.1.4

