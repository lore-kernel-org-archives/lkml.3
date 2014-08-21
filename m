Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaHUHm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:42:29 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:40505 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaHUHm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:42:28 -0400
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] checkpatch: update $allowed_asm_includes macros, add reboot.h and time.h
Date: Thu, 21 Aug 2014 11:43:12 +0400
Message-Id: <1408606992-9977-1-git-send-email-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several architectures (e.g. x86, MIPS, Blackfin) have asm/reboot.h and
asm/time.h header files, which are not included in linux/reboot.h and
linux/time.h headers. This lead to generation of false positive errors.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 scripts/checkpatch.pl | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 31a731e..29d6b56 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -425,7 +425,9 @@ foreach my $entry (@mode_permission_funcs) {
 
 our $allowed_asm_includes = qr{(?x:
 	irq|
-	memory
+	memory|
+	time|
+	reboot
 )};
 # memory.h: ARM has a custom one
 
-- 
1.8.1.5

