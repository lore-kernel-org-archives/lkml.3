Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaLBEbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:31:09 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:45609 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaLBEbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:31:05 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: remove redundant -rR flag of hdr-inst
Date: Tue,  2 Dec 2014 13:30:46 +0900
Message-Id: <1417494646-24528-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing -rR for "make headers_install" is redundant because
the top Makefile has already set -rR to MAKEFLAGS.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 scripts/Kbuild.include | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index eb14d83..c201ff3 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -193,10 +193,10 @@ modbuiltin := -f $(srctree)/scripts/Makefile.modbuiltin obj
 clean := -f $(srctree)/scripts/Makefile.clean obj
 
 ###
-# Shorthand for $(Q)$(MAKE) -rR -f scripts/Makefile.headersinst obj=
+# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.headersinst obj=
 # Usage:
 # $(Q)$(MAKE) $(hdr-inst)=dir
-hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
+hdr-inst := -f $(srctree)/scripts/Makefile.headersinst obj
 
 # Prefix -I with $(srctree) if it is not an absolute path.
 # skip if -I has no parameter
-- 
1.9.1

