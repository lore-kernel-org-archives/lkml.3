Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbaFCUBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:01:23 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:21040 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbaFCUBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:01:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAOABYpjlNbsmtf/2dsb2JhbABZgwerXgQDAQEBBQGYHIEOF3SDAiOBGjeIRgHRKxeFVYgZZB2EKgSPS4o/ix2IFoM6O4Ew
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/file.c: use SIZE_MAX instead of ~(size_t)0
Date: Tue,  3 Jun 2014 22:00:08 +0200
Message-Id: <1401825608-7037-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel.h definition.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 8f294cf..d63f731 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -27,7 +27,7 @@ int sysctl_nr_open __read_mostly = 1024*1024;
 int sysctl_nr_open_min = BITS_PER_LONG;
 /* our max() is unusable in constant expressions ;-/ */
 #define __const_max(x, y) ((x) < (y) ? (x) : (y))
-int sysctl_nr_open_max = __const_max(INT_MAX, ~(size_t)0/sizeof(void *)) &
+int sysctl_nr_open_max = __const_max(INT_MAX, SIZE_MAX/sizeof(void *)) &
 			 -BITS_PER_LONG;
 
 static void *alloc_fdmem(size_t size)
-- 
1.8.4.5

