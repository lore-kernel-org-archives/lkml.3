Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3HVOxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:53:19 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:62118 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3HVOxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:53:18 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>, Chris Zankel <chris@zankel.net>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH 1/3] xtensa: don't use echo -e needlessly
Date: Thu, 22 Aug 2013 18:53:04 +0400
Message-Id: <1377183186-8407-2-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1377183186-8407-1-git-send-email-jcmvbkbc@gmail.com>
References: <1377183186-8407-1-git-send-email-jcmvbkbc@gmail.com>
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

