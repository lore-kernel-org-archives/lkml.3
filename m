Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaCaDGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 23:06:43 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:49414 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaCaDGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 23:06:42 -0400
Message-ID: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] ipc,shm: increase default size for shmmax
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr@hp.com>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Sun, 30 Mar 2014 20:06:39 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

The default size is, and always has been, 32Mb. Today, in the
XXI century, it seems that this value is rather small, making
users have to increase it via sysctl, which can cause unnecessary
work and userspace application workarounds[1]. I have arbitrarily
chosen a 4x increase, leaving it at 128Mb, and naturally, the
same goes for shmall. While it may make more sense to set the value
based on the system memory, this limit must be the same across all
systems, and left to users to change if needed.

[1]: http://rhaas.blogspot.com/2012/06/absurd-shared-memory-limits.html

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/uapi/linux/shm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
index 78b6941..754b605 100644
--- a/include/uapi/linux/shm.h
+++ b/include/uapi/linux/shm.h
@@ -12,7 +12,7 @@
  * be increased by sysctl
  */
 
-#define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
+#define SHMMAX 0x8000000		 /* max shared seg size (bytes) */
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
 #ifndef __KERNEL__
-- 
1.8.1.4



