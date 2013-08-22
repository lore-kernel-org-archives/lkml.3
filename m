Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3HVUZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:25:46 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59762 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3HVUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:25:41 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>, Chris Zankel <chris@zankel.net>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH v2 1/5] xtensa: don't use echo -e needlessly
Date: Fri, 23 Aug 2013 00:25:21 +0400
Message-Id: <1377203125-22934-2-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
References: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-e is not needed to output strings without escape sequences. This breaks
big endian FSF build when the shell is dash, because its builtin echo
doesn't understand '-e' switch and outputs it in the echoed string.

Cc: Chris Zankel <chris@zankel.net>
Cc: linux-xtensa@linux-xtensa.org
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/Makefile      |    4 ++--
 arch/xtensa/boot/Makefile |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/Makefile b/arch/xtensa/Makefile
index 136224b..81250ec 100644
--- a/arch/xtensa/Makefile
+++ b/arch/xtensa/Makefile
@@ -55,10 +55,10 @@ ifneq ($(CONFIG_LD_NO_RELAX),)
 LDFLAGS := --no-relax
 endif
 
-ifeq ($(shell echo -e __XTENSA_EB__ | $(CC) -E - | grep -v "\#"),1)
+ifeq ($(shell echo __XTENSA_EB__ | $(CC) -E - | grep -v "\#"),1)
 CHECKFLAGS += -D__XTENSA_EB__
 endif
-ifeq ($(shell echo -e __XTENSA_EL__ | $(CC) -E - | grep -v "\#"),1)
+ifeq ($(shell echo __XTENSA_EL__ | $(CC) -E - | grep -v "\#"),1)
 CHECKFLAGS += -D__XTENSA_EL__
 endif
 
diff --git a/arch/xtensa/boot/Makefile b/arch/xtensa/boot/Makefile
index 64ffc4b..ca20a89 100644
--- a/arch/xtensa/boot/Makefile
+++ b/arch/xtensa/boot/Makefile
@@ -12,7 +12,7 @@
 KBUILD_CFLAGS	+= -fno-builtin -Iarch/$(ARCH)/boot/include
 HOSTFLAGS	+= -Iarch/$(ARCH)/boot/include
 
-BIG_ENDIAN	:= $(shell echo -e __XTENSA_EB__ | $(CC) -E - | grep -v "\#")
+BIG_ENDIAN	:= $(shell echo __XTENSA_EB__ | $(CC) -E - | grep -v "\#")
 
 export ccflags-y
 export BIG_ENDIAN
-- 
1.7.7.6

