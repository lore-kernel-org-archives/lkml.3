Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaHPS77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 14:59:59 -0400
Received: from fr1.as29.net ([62.210.131.231]:52002 "EHLO
	toothrot.meleeweb.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaHPS75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 14:59:57 -0400
From: Bertrand Jacquin <beber@meleeweb.net>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org
Cc: Bertrand Jacquin <beber@meleeweb.net>, linux-kernel@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>
Subject: [PATCH 1/3] modinst: wrap long lines in order to enhance cmd_modules_install
Date: Sat, 16 Aug 2014 20:50:14 +0200
Message-Id: <1408215016-1848-2-git-send-email-beber@meleeweb.net>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1408215016-1848-1-git-send-email-beber@meleeweb.net>
References: <1408215016-1848-1-git-send-email-beber@meleeweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: shouldn't we use 'install -D $(2)/$@ $@' instead of mkdir
and cp ?

Reviewed-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Bertrand Jacquin <beber@meleeweb.net>
---
 scripts/Makefile.modinst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index 95ec7b3..aa911b5 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -18,7 +18,11 @@ __modinst: $(modules)
 
 # Don't stop modules_install if we can't sign external modules.
 quiet_cmd_modules_install = INSTALL $@
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@) ; $(mod_sign_cmd) $(2)/$(notdir $@) $(patsubst %,|| true,$(KBUILD_EXTMOD))
+      cmd_modules_install = \
+    mkdir -p $(2) ; \
+    cp $@ $(2) ; \
+    $(mod_strip_cmd) $(2)/$(notdir $@) ; \
+    $(mod_sign_cmd) $(2)/$(notdir $@) $(patsubst %,|| true,$(KBUILD_EXTMOD))
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
-- 
2.0.4

