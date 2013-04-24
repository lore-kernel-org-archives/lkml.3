Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab3DXWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:25:58 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:59525 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3DXWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:25:57 -0400
From: Tom Rini <trini@ti.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] modpost.c: Add .text.unlikely to TEXT_SECTIONS
Date: Wed, 24 Apr 2013 18:26:03 -0400
Message-Id: <1366842363-7513-1-git-send-email-trini@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent gcc's may place functions into the .text.unlikely section and we
need to check this section as well for section mismatches now otherwise
we may have false negatives for this test.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Tom Rini <trini@ti.com>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ff36c50..13ff12f 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -880,7 +880,7 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
 
 #define DATA_SECTIONS ".data$", ".data.rel$"
-#define TEXT_SECTIONS ".text$"
+#define TEXT_SECTIONS ".text$", ".text.unlikely$"
 
 #define INIT_SECTIONS      ".init.*"
 #define CPU_INIT_SECTIONS  ".cpuinit.*"
-- 
1.7.9.5

