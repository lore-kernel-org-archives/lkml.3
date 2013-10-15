Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3JOKtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:49:55 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51697 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab3JOKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:49:53 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] virtio tools: use ansi versions of asm and volatile
Date: Tue, 15 Oct 2013 16:13:10 +0530
Message-Id: <1381833790-18687-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm and volatile are provided for backward compatibility; use the ansi
versions __asm__ and __volatile__.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/virtio/asm/barrier.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtio/asm/barrier.h b/tools/virtio/asm/barrier.h
index aff61e1..b2fbbfc 100644
--- a/tools/virtio/asm/barrier.h
+++ b/tools/virtio/asm/barrier.h
@@ -1,5 +1,5 @@
 #if defined(__i386__) || defined(__x86_64__)
-#define barrier() asm volatile("" ::: "memory")
+#define barrier() __asm__ __volatile__("" ::: "memory")
 #define mb() __sync_synchronize()
 
 #define smp_mb()	mb()
-- 
1.8.4.477.g5d89aa9

