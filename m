Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935079Ab3E2HSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:18:31 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:51775 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759493Ab3E2HSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:18:30 -0400
Message-ID: <1369811908.23034.1.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix warning typo "CONFIG_RELCOATABLE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 29 May 2013 09:18:28 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2013 07:18:28.0918 (UTC) FILETIME=[B7A54D60:01CE5C3C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo "CONFIG_RELCOATABLE" in a warning message. While we're at it,
also make that warning an actual sentence and fix comparable typos in
some comments.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/powerpc/relocs_check.pl | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/relocs_check.pl b/arch/powerpc/relocs_check.pl
index 7f5b838..3f46e8b 100755
--- a/arch/powerpc/relocs_check.pl
+++ b/arch/powerpc/relocs_check.pl
@@ -7,7 +7,7 @@
 # as published by the Free Software Foundation; either version
 # 2 of the License, or (at your option) any later version.
 
-# This script checks the relcoations of a vmlinux for "suspicious"
+# This script checks the relocations of a vmlinux for "suspicious"
 # relocations.
 
 use strict;
@@ -28,7 +28,7 @@ open(FD, "$objdump -R $vmlinux|") or die;
 while (<FD>) {
 	study $_;
 
-	# Only look at relcoation lines.
+	# Only look at relocation lines.
 	next if (!/\s+R_/);
 
 	# These relocations are okay
@@ -45,7 +45,7 @@ while (<FD>) {
 		 /\bR_PPC_ADDR16_HA\b/ or /\bR_PPC_RELATIVE\b/ or
 		 /\bR_PPC_NONE\b/);
 
-	# If we see this type of relcoation it's an idication that
+	# If we see this type of relocation it's an idication that
 	# we /may/ be using an old version of binutils.
 	if (/R_PPC64_UADDR64/) {
 		$old_binutils++;
@@ -61,6 +61,6 @@ if ($bad_relocs_count) {
 }
 
 if ($old_binutils) {
-	print "WARNING: You need at binutils >= 2.19 to build a ".
-	      "CONFIG_RELCOATABLE kernel\n";
+	print "WARNING: You need at least binutils >= 2.19 to build a ".
+	      "CONFIG_RELOCATABLE kernel\n";
 }
-- 
1.7.11.7

