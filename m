Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3IYKsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:48:15 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51016 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3IYKsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:48:13 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v1 7/7] jump_label: use defined macros instead of hard-coding for better readability
Date: Wed, 25 Sep 2013 18:44:27 +0800
Message-Id: <1380105868-31985-8-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use macro JUMP_LABEL_TRUE_BRANCH instead of hard-coding for better
readability.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 include/linux/jump_label.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index a507907..b697fbd 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -116,7 +116,8 @@ extern void static_key_slow_dec(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 
 #define STATIC_KEY_INIT_TRUE ((struct static_key) \
-	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
+	{ .enabled = ATOMIC_INIT(1), \
+	  .entries = (void *)JUMP_LABEL_TRUE_BRANCH })
 #define STATIC_KEY_INIT_FALSE ((struct static_key) \
 	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
 
-- 
1.8.1.2

