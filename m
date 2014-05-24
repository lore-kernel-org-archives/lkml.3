Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaEXHEM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:04:12 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38283 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaEXHCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:25 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 09/24] ARM64:ILP32: Use the same syscall names as LP64.
Date: Sat, 24 May 2014 00:02:04 -0700
Message-Id: <1400914939-9708-10-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define __SYSCALL_NONCOMPAT so we use the 64bit naming scheme for ILP32.

Signed-off-by: Andrew Pinski <apinski@cavium.com>

---
 arch/arm64/include/uapi/asm/unistd.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
index 1caadc2..067eab0 100644
--- a/arch/arm64/include/uapi/asm/unistd.h
+++ b/arch/arm64/include/uapi/asm/unistd.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2014 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -13,4 +14,10 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+
+/* For ILP32 AARCH64, we want to use the non compat names. */
+#if defined(__aarch64__) && defined(__ILP32__)
+#define __SYSCALL_NONCOMPAT
+#endif
+
 #include <asm-generic/unistd.h>
-- 
1.7.2.5

