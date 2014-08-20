Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaHTJaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:30:14 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56983 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaHTJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:30:11 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
X-Google-Original-From: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
To: <drjones@redhat.com>, <konrad.wilk@oracle.com>,
        <raghavendra.kt@linux.vnet.ibm.com>, <mingo@kernel.org>,
        <davem@davemloft.net>, <hannes@stressinduktion.org>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH 1/1] jump_label: tidy jump_label_ratelimit.h 
Date: Wed, 20 Aug 2014 17:29:42 +0800
Message-Id: <1408526982-23196-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jump_label_ratelimit.h is split from jump_label.h to enable the 
includers who don't want linux/workqueue.h.
As HAVE_JUMP_LABEL is only defined in jump_label.h, will following  
patch makes jump_labe_ratelimit.h more tidy?

Compiled and Tested in x86_64
Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 include/linux/jump_label_ratelimit.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
index 089f70f..0d34d7e 100644
--- a/include/linux/jump_label_ratelimit.h
+++ b/include/linux/jump_label_ratelimit.h
@@ -4,15 +4,12 @@
 #include <linux/jump_label.h>
 #include <linux/workqueue.h>
 
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+#ifdef HAVE_JUMP_LABEL
 struct static_key_deferred {
 	struct static_key key;
 	unsigned long timeout;
 	struct delayed_work work;
 };
-#endif
-
-#ifdef HAVE_JUMP_LABEL
 extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
 extern void
 jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
-- 
1.7.10.4

