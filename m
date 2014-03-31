Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaCaHlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:41:52 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:55588 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaCaHlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:41:49 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: [PATCH] kbuild: create a build directory automatically for out-of-tree build
Date: Mon, 31 Mar 2014 16:41:36 +0900
Message-Id: <1396251696-14815-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kbuild supports saving output files in a separate directory.
But the build directory must be created beforehand. For example,

  $ mkdir -p dir/to/store/output/files
  $ make O=dir/to/store/output/files defconfig

Creating a build directory automatically would be useful.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---
 Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 575e1f8..35b5b7e 100644
--- a/Makefile
+++ b/Makefile
@@ -120,9 +120,10 @@ ifneq ($(KBUILD_OUTPUT),)
 # Invoke a second make in the output directory, passing relevant variables
 # check that the output directory actually exists
 saved-output := $(KBUILD_OUTPUT)
-KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
+KBUILD_OUTPUT := $(shell mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) \
+								&& /bin/pwd)
 $(if $(KBUILD_OUTPUT),, \
-     $(error output directory "$(saved-output)" does not exist))
+     $(error failed to create output directory "$(saved-output)"))
 
 PHONY += $(MAKECMDGOALS) sub-make
 
-- 
1.8.3.2

