Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaGMSnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:43:49 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:60652 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaGMSn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:43:28 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4/6] samples: use uapiprogs support for hidraw
Date: Sun, 13 Jul 2014 20:42:52 +0200
Message-Id: <1405276974-17323-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405276974-17323-1-git-send-email-sam@ravnborg.org>
References: <20140713183636.GA17241@ravnborg.org>
 <1405276974-17323-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce complexity of hidraw Makefile by introducing use of uapiprogs support.
Build testet with i386 + sparc32.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Herrmann <dh.herrmann@googlemail.com>
Cc: Jiri Kosina <jkosina@suse.cz>

---
 samples/Makefile        |  2 +-
 samples/hidraw/Makefile | 11 +----------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index b4d7d66..8fc6c45 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -12,4 +12,4 @@ obj-$(CONFIG_SAMPLES) += kdb/
 
 # user space programs
 subdir-$(CONFIG_SAMPLES) += seccomp
-obj-$(CONFIG_SAMPLES) += hidraw/
+subdir-$(CONFIG_SAMPLES) += hidraw
diff --git a/samples/hidraw/Makefile b/samples/hidraw/Makefile
index 382eeae..c2d2544 100644
--- a/samples/hidraw/Makefile
+++ b/samples/hidraw/Makefile
@@ -1,10 +1 @@
-# kbuild trick to avoid linker error. Can be omitted if a module is built.
-obj- := dummy.o
-
-# List of programs to build
-hostprogs-y := hid-example
-
-# Tell kbuild to always build the programs
-always := $(hostprogs-y)
-
-HOSTCFLAGS_hid-example.o += -I$(objtree)/usr/include
+uapiprogs-y := hid-example
-- 
1.9.3

