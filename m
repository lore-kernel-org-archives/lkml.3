Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaCDSE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:04:27 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64887 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaCDSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:04:26 -0500
From: Doug <doug.lkml@gmail.com>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Doug <doug.lkml@gmail.com>
Subject: [PATCH 1/1] sparc64:tsb.c:use array size macro rather than number
Date: Tue,  4 Mar 2014 23:34:08 +0530
Message-Id: <1393956248-9354-1-git-send-email-doug.lkml@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a small patch which uses ARRAY_SIZE macro
rather than a number to make code readability better.

Signed-off-by: Doug <doug.lkml@gmail.com>
---
 arch/sparc/mm/tsb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 3b3a360..f5d506f 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -273,7 +273,7 @@ void __init pgtable_cache_init(void)
 		prom_halt();
 	}
 
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < ARRAY_SIZE(tsb_cache_names); i++) {
 		unsigned long size = 8192 << i;
 		const char *name = tsb_cache_names[i];
 
-- 
1.8.1.2

