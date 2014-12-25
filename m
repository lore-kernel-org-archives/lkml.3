Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaLYFbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 00:31:53 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:62781 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaLYFbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 00:31:48 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Michal Marek <mmarek@suse.cz>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] kbuild,gcov: simplify kernel/gcov/Makefile more
Date: Thu, 25 Dec 2014 14:31:28 +0900
Message-Id: <1419485488-22336-7-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419485488-22336-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1419485488-22336-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_GCOV_FORMAT_3_4 / _4_7 / _AUTODETECT are exclusive.
Compare the CC version only when _AUTODETECT is enabled.

This change should have no impact.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---

 kernel/gcov/Makefile | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/kernel/gcov/Makefile b/kernel/gcov/Makefile
index 69b3515..752d648 100644
--- a/kernel/gcov/Makefile
+++ b/kernel/gcov/Makefile
@@ -1,22 +1,7 @@
 ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
 
-# if-lt
-# Usage VAR := $(call if-lt, $(a), $(b))
-# Returns 1 if (a < b)
-if-lt = $(shell [ $(1) -lt $(2) ] && echo 1)
-
-ifeq ($(CONFIG_GCOV_FORMAT_3_4),y)
-  cc-ver := 0304
-else ifeq ($(CONFIG_GCOV_FORMAT_4_7),y)
-  cc-ver := 0407
-else
-  cc-ver := $(cc-version)
-endif
-
 obj-y := base.o fs.o
-
-ifeq ($(call if-lt, $(cc-ver), 0407),1)
-  obj-y += gcc_3_4.o
-else
-  obj-y += gcc_4_7.o
-endif
+obj-$(CONFIG_GCOV_FORMAT_3_4) += gcc_3_4.o
+obj-$(CONFIG_GCOV_FORMAT_4_7) += gcc_4_7.o
+obj-$(CONFIG_GCOV_FORMAT_AUTODETECT) += $(call cc-ifversion, -lt, 0407, \
+							gcc_3_4.o, gcc_4_7.o)
-- 
1.9.1

