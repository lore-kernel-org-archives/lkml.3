Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbbAHI34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:29:56 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:38770 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbbAHI3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:29:54 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: drop $(version_h) from MRPROPER_FILES
Date: Thu,  8 Jan 2015 17:29:38 +0900
Message-Id: <1420705778-22468-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now $(version_h) is include/generated/uapi/linux/version.h.

$(version_h) in MRPROPER_FILES is redundant because it is covered
by include/generated in MRPROPER_DIRS.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index eb4eca5..a34b061 100644
--- a/Makefile
+++ b/Makefile
@@ -1171,7 +1171,7 @@ CLEAN_DIRS  += $(MODVERDIR)
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config usr/include include/generated          \
 		  arch/*/include/generated .tmp_objdiff
-MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
+MRPROPER_FILES += .config .config.old .version .old_version \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.priv signing_key.x509 x509.genkey		\
 		  extra_certificates signing_key.x509.keyid		\
-- 
1.9.1

