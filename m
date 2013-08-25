Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3HYHRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 03:17:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:35604 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab3HYHQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 03:16:57 -0400
From: Kevin Hao <haokexin@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] jump_label: also include linux/atomic.h when jump label is enabled
Date: Sun, 25 Aug 2013 15:15:49 +0800
Message-ID: <1377414952-15995-3-git-send-email-haokexin@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377414952-15995-1-git-send-email-haokexin@gmail.com>
References: <1377414952-15995-1-git-send-email-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct static_key will have a atomic_t type member no matter
whether jump label is enabled or not. We would include linux/atomic.h
when jump label is not enabled. But it also does make sense to include
this header file when jump label is enabled.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 include/linux/jump_label_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jump_label_base.h b/include/linux/jump_label_base.h
index 20df08f..d5c8f4b 100644
--- a/include/linux/jump_label_base.h
+++ b/include/linux/jump_label_base.h
@@ -5,6 +5,8 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
+#include <linux/atomic.h>
+
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 
 struct static_key {
@@ -77,8 +79,6 @@ extern void jump_label_apply_nops(struct module *mod);
 
 #else  /* !HAVE_JUMP_LABEL */
 
-#include <linux/atomic.h>
-
 struct static_key {
 	atomic_t enabled;
 };
-- 
1.8.3.1

