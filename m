Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaEBUYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:24:08 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:45389 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaEBUYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:24:07 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Streetman <ddstreet@ieee.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] plist: include -DDEBUG if CONFIG_DEBUG_PI_LIST
Date: Fri,  2 May 2014 16:23:43 -0400
Message-Id: <1399062223-18928-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/plist.c uses pr_debug() in its test function, which is compiled
and run only when CONFIG_DEBUG_PI_LIST in set; however pr_debug()
is compiled out unless -DDEBUG is set for the file.

Update lib/Makefile to add -DDEBUG to CFLAGS_plist.o if
CONFIG_DEBUG_PI_LIST is set, so that the pr_debug() output from
plist_test() is shown.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 lib/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/Makefile b/lib/Makefile
index 0cd7b68..fd1f4c8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -39,6 +39,10 @@ CFLAGS_kobject.o += -DDEBUG
 CFLAGS_kobject_uevent.o += -DDEBUG
 endif
 
+ifeq ($(CONFIG_DEBUG_PI_LIST),y)
+CFLAGS_plist.o += -DDEBUG
+endif
+
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
 obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
-- 
1.8.3.1

