Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3HWIj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab3HWIj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:39:56 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jstancek@redhat.com, keescook@chromium.org, peter.oberparleiter@de.ibm.com,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com
Subject: [RFC PATCH 3/4] gcov: compile specific gcov implementation based on gcc version
Date: Fri, 23 Aug 2013 10:39:35 +0200
Message-Id: <1377247176-13537-4-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1377247176-13537-1-git-send-email-fhrbata@redhat.com>
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile the correct gcov implementation file for a specific gcc version. In
the future, if another file is added, the conditions will need to be somehow
adjusted to if-elif-else case, but at this point the simple cc-ifversion should
be enough.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
---
 kernel/gcov/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/gcov/Makefile b/kernel/gcov/Makefile
index e97ca59..d57b712 100644
--- a/kernel/gcov/Makefile
+++ b/kernel/gcov/Makefile
@@ -1,3 +1,6 @@
 ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
 
-obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o gcc_3_4.o
+obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o
+
+obj-$(CONFIG_GCOV_KERNEL) += $(call cc-ifversion, -ge, 0407, gcc_4_7.o)
+obj-$(CONFIG_GCOV_KERNEL) += $(call cc-ifversion, -lt, 0407, gcc_3_4.o)
-- 
1.8.3.1

