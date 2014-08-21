Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaHUClr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:41:47 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35921 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaHUClp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:41:45 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
X-Google-Original-From: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
To: <benh@kernel.crashing.org>, <paulus@samba.org>, <mpe@ellerman.id.au>,
        <paulmck@linux.vnet.ibm.com>, <anton@samba.org>,
        <aneesh.kumar@linux.vnet.ibm.com>, <jk@ozlabs.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <jbaron@akamai.com>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH 1/1] powerpc/jump_label: use HAVE_JUMP_LABEL?  
Date: Thu, 21 Aug 2014 10:41:23 +0800
Message-Id: <1408588883-26783-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_JUMP_LABEL doesn't ensure HAVE_JUMP_LABEL, if it
is not the case use maintainers's own mutex to guard
the modification of global values.


Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/powerpc/platforms/powernv/opal-tracepoints.c |    2 +-
 arch/powerpc/platforms/pseries/lpar.c             |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-tracepoints.c b/arch/powerpc/platforms/powernv/opal-tracepoints.c
index d8a000a..ae14c40 100644
--- a/arch/powerpc/platforms/powernv/opal-tracepoints.c
+++ b/arch/powerpc/platforms/powernv/opal-tracepoints.c
@@ -2,7 +2,7 @@
 #include <linux/jump_label.h>
 #include <asm/trace.h>
 
-#ifdef CONFIG_JUMP_LABEL
+#ifdef HAVE_JUMP_LABEL
 struct static_key opal_tracepoint_key = STATIC_KEY_INIT;
 
 void opal_tracepoint_regfunc(void)
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 34e6423..059cfe0 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -642,7 +642,7 @@ EXPORT_SYMBOL(arch_free_page);
 #endif
 
 #ifdef CONFIG_TRACEPOINTS
-#ifdef CONFIG_JUMP_LABEL
+#ifdef HAVE_JUMP_LABEL
 struct static_key hcall_tracepoint_key = STATIC_KEY_INIT;
 
 void hcall_tracepoint_regfunc(void)
-- 
1.7.10.4

