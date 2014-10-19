Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaJSQH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 12:07:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29074 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaJSQHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 12:07:55 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] kernel: use the gnu89 standard explicitly
Date: Sun, 19 Oct 2014 12:07:42 -0400
Message-Id: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc5 changes the default standard to c11, rather than gnu89, which
makes kernel build unhappy.

Explicitly define the kernel standard to be gnu89 which should
keep everything working exactly like it was before gcc5.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index dd7e1cb..43f31cb 100644
--- a/Makefile
+++ b/Makefile
@@ -642,7 +642,8 @@ ifdef CONFIG_READABLE_ASM
 # partial inlining inlines only parts of functions
 KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
                  $(call cc-option,-fno-ipa-cp-clone,) \
-                 $(call cc-option,-fno-partial-inlining)
+                 $(call cc-option,-fno-partial-inlining,) \
+                 $(call cc-option,-std=gnu89)
 endif
 
 ifneq ($(CONFIG_FRAME_WARN),0)
-- 
1.7.10.4

