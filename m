Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3BYDDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:03:55 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:42009 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619Ab3BYDDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:03:54 -0500
From: Bin Wang <wbin00@gmail.com>
To: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bin Wang <wbin00@gmail.com>
Subject: [PATCH] scripts/package/Makefile: compare objtree with srctree instead of test KBUILD_OUTPUT
Date: Mon, 25 Feb 2013 11:02:50 +0800
Message-Id: <1361761370-9426-1-git-send-email-wbin00@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KBUILD_OUTPUT is always empty here, so it is useless to test it. But
while use O=.., objtree and srctree will be different. I compare them
instead.
---
 scripts/package/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 87bf080..d7b3285 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -36,7 +36,7 @@ $(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile
 	$(CONFIG_SHELL) $(MKSPEC) > $@
 
 rpm-pkg rpm: $(objtree)/kernel.spec FORCE
-	@if test -n "$(KBUILD_OUTPUT)"; then \
+	@if test "$(objtree)" != "$(srctree)"; then \
 		echo "Building source + binary RPM is not possible outside the"; \
 		echo "kernel source tree. Don't set KBUILD_OUTPUT, or use the"; \
 		echo "binrpm-pkg target instead."; \
-- 
1.8.1.4

