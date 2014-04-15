Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaDOQFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:05:55 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:50592 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDOQFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:05:53 -0400
MIME-Version: 1.0
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 15 Apr 2014 12:05:22 -0400
Message-ID: <CAJhHMCAnYPy0+qD-1KBnJPLt3XgAjdR12j+ySSnPgmZcpbE7HQ@mail.gmail.com>
Subject: [PATCH 1/1] include/linux/compiler-intel.h: remove duplicate definition
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

barrier is already defined as __memory_barrier in compiler.h
Remove this unnecessary redefinition.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/compiler-intel.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/compiler-
intel.h b/include/linux/compiler-intel.h
index 5529c52..ba147a1 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -13,12 +13,9 @@
 /* Intel ECC compiler doesn't support gcc specific asm stmts.
  * It uses intrinsics to do the equivalent things.
  */
-#undef barrier
 #undef RELOC_HIDE
 #undef OPTIMIZER_HIDE_VAR

-#define barrier() __memory_barrier()
-
 #define RELOC_HIDE(ptr, off)                                   \
   ({ unsigned long __ptr;                                      \
      __ptr = (unsigned long) (ptr);                            \
