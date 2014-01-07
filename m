Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaAGJc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:32:59 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48809 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbaAGJcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:32:50 -0500
From: Ethan Zhao <ethan.kernel@gmail.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ethan Zhao <ethan.kernel@gmail.com>
Subject: [PATCH] sparc: replace __GFP_NOFAIL with GFP_ATOMIC in mdesc_kmalloc()
Date: Tue,  7 Jan 2014 17:31:17 +0800
Message-Id: <1389087077-311-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has kmalloc() failure checking there, so it is unnecessary to allocate with
__GFP_NOFAIL flag that might block forever.

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
 arch/sparc/kernel/mdesc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index b90bf23..e8d678c 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -136,7 +136,7 @@ static struct mdesc_handle *mdesc_kmalloc(unsigned int mdesc_size)
 		       sizeof(struct mdesc_hdr) +
 		       mdesc_size);
 
-	base = kmalloc(handle_size + 15, GFP_KERNEL | __GFP_NOFAIL);
+	base = kmalloc(handle_size + 15, GFP_KERNEL | GFP_ATOMIC);
 	if (base) {
 		struct mdesc_handle *hp;
 		unsigned long addr;
-- 
1.8.3.4 (Apple Git-47)

