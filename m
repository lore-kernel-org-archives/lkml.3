Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab3EBMvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:51:14 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:42264 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3EBMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:51:12 -0400
From: Robert Richter <rric@kernel.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH] Makefile: Fix install error with make -j option
Date: Thu,  2 May 2013 14:50:37 +0200
Message-Id: <1367499037-8350-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Make modules_install fails with -j option:

   DEPMOD
 Usage: .../.source/linux/scripts/depmod.sh /sbin/depmod <kernelrelease>
 make[1]: *** [_modinst_post] Error 1

Adding kernelrelease dependency to fix this.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 46263d8..0205e79 100644
--- a/Makefile
+++ b/Makefile
@@ -979,7 +979,7 @@ _modinst_:
 # boot a modules.dep even before / is mounted read-write.  However the
 # boot script depmod is the master version.
 PHONY += _modinst_post
-_modinst_post: _modinst_
+_modinst_post: include/config/kernel.release _modinst_
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst
 	$(call cmd,depmod)
 
-- 
1.8.1.1

