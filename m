Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3JER57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:57:59 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:51075
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575Ab3JER55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:57:57 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Oct 2013 13:57:57 EDT
Date: Sat, 5 Oct 2013 13:39:30 -0400
From: Ulrich Drepper <drepper@akkadia.org>
Message-Id: <201310051739.r95HdUAe003537@drepperk.user.openhosting.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: remove duplicate block from Makefile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a merge error, the code is duplicated with the first
copy doing something else as well.  Just remove the second block.

Signed-off-by: Ulrich Drepper <drepper@gmail.com>

 Makefile |    8 --------
 1 file changed, 8 deletions(-)


Index: perf/config/Makefile
===================================================================
--- perf.orig/config/Makefile
+++ perf/config/Makefile
@@ -200,14 +200,6 @@ endif # NO_DWARF
 
 endif # NO_LIBELF
 
-ifndef NO_LIBELF
-CFLAGS += -DLIBELF_SUPPORT
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-  CFLAGS += -DLIBELF_MMAP
-endif # try-cc
-endif # NO_LIBELF
-
 # There's only x86 (both 32 and 64) support for CFI unwind so far
 ifneq ($(ARCH),x86)
   NO_LIBUNWIND := 1
