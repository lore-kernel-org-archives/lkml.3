Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855Ab3ECMHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:07:47 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:39611 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754Ab3ECMHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:07:45 -0400
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH] tools: Get only verbose output with V=1
Date: Fri,  3 May 2013 14:07:31 +0200
Message-Id: <1367582851-11944-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Fix having verbose build with V=0, e.g:

 make V=0 -C tools/ perf

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 tools/scripts/Makefile.include | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 2964b96..14b349f 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -57,7 +57,7 @@ QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
+ifneq ($(V),1)
 	QUIET_CC       = @echo '   ' CC $@;
 	QUIET_AR       = @echo '   ' AR $@;
 	QUIET_LINK     = @echo '   ' LINK $@;
-- 
1.8.1.1

