Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaJTClP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 22:41:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25476 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaJTClM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 22:41:12 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: kirill@shutemov.name, viro@ZenIV.linux.org.uk, pinskia@gmail.com,
        joe@perches.com, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2] kernel: use the gnu89 standard explicitly
Date: Sun, 19 Oct 2014 22:40:55 -0400
Message-Id: <1413772855-8613-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc5 changes the default standard to c11, which makes kernel
build unhappy.

Explicitly define the kernel standard to be gnu89 which should
keep everything working exactly like it was before gcc5.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---

Changes from v1:
  - I've accidently placed the statement in a CONFIG_READABLE_ASM.
It shouldn't be there.

 Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index dd7e1cb..eb0c026 100644
--- a/Makefile
+++ b/Makefile
@@ -625,6 +625,7 @@ all: vmlinux
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 KBUILD_CFLAGS	+= $(call cc-option,-fno-delete-null-pointer-checks,)
+KBUILD_CFLAGS	+= $(call cc-option,-std=gnu89,)
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
-- 
1.7.10.4

