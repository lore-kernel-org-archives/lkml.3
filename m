Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaGMSoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:44:11 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:60670 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaGMSn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:43:29 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 6/6] samples: use uapiprogs support for uhid
Date: Sun, 13 Jul 2014 20:42:54 +0200
Message-Id: <1405276974-17323-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405276974-17323-1-git-send-email-sam@ravnborg.org>
References: <20140713183636.GA17241@ravnborg.org>
 <1405276974-17323-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uhid was not included in the regular builds as it was not wired
up in samples/Makefile.

Fix build on sparc32 by defining __USE_GNU to get visibility to O_CLOEXEC.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 samples/Makefile            |  1 +
 samples/uhid/Makefile       | 11 +----------
 samples/uhid/uhid-example.c |  5 ++++-
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 8fc6c45..29a09bd 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_SAMPLES) += kdb/
 # user space programs
 subdir-$(CONFIG_SAMPLES) += seccomp
 subdir-$(CONFIG_SAMPLES) += hidraw
+subdir-$(CONFIG_SAMPLES) += uhid
diff --git a/samples/uhid/Makefile b/samples/uhid/Makefile
index c95a696..75ff2bb 100644
--- a/samples/uhid/Makefile
+++ b/samples/uhid/Makefile
@@ -1,10 +1 @@
-# kbuild trick to avoid linker error. Can be omitted if a module is built.
-obj- := dummy.o
-
-# List of programs to build
-hostprogs-y := uhid-example
-
-# Tell kbuild to always build the programs
-always := $(hostprogs-y)
-
-HOSTCFLAGS_uhid-example.o += -I$(objtree)/usr/include
+uapiprogs-y := uhid-example
diff --git a/samples/uhid/uhid-example.c b/samples/uhid/uhid-example.c
index f25a5ef..e4379c8 100644
--- a/samples/uhid/uhid-example.c
+++ b/samples/uhid/uhid-example.c
@@ -37,7 +37,6 @@
  */
 
 #include <errno.h>
-#include <fcntl.h>
 #include <poll.h>
 #include <stdbool.h>
 #include <stdio.h>
@@ -45,6 +44,10 @@
 #include <string.h>
 #include <termios.h>
 #include <unistd.h>
+
+#define __USE_GNU
+#include <fcntl.h>
+
 #include <linux/uhid.h>
 
 /*
-- 
1.9.3

