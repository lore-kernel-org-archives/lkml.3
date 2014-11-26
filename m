Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaKZOMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:12:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbaKZOMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:12:35 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: [PATCH] kbuild: Remove duplicate $(cmd) definition in Makefile.clean
Date: Wed, 26 Nov 2014 15:12:11 +0100
Message-Id: <1417011131-19518-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makefile.clean includes Kbuild.include since commit 371fdc77
(kbuild: collect shorthands into scripts/Kbuild.include), so there is no
need for a local copy.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Makefile.clean | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index 0aa91a0..1bca180 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -88,11 +88,6 @@ PHONY += $(subdir-ymn)
 $(subdir-ymn):
 	$(Q)$(MAKE) $(clean)=$@
 
-# If quiet is set, only print short version of command
-
-cmd = @$(if $($(quiet)cmd_$(1)),echo '  $($(quiet)cmd_$(1))' &&) $(cmd_$(1))
-
-
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
 
-- 
2.1.2

