Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3ANDEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 22:04:48 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33030 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab3ANDEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 22:04:47 -0500
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH] scripts: checkpatch.pl: Fix misused memset detection
Date: Mon, 14 Jan 2013 13:04:39 +1000
Message-Id: <1358132679-12235-1-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, checking memset declarations would generate
a lot of errors saying that $ms_size was not defined.

This commit fixes that.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 519a2d9..0b927ab 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3377,8 +3377,8 @@ sub process {
 		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*$FuncArg\s*\)/s) {
 
 			my $ms_addr = $2;
-			my $ms_val = $7;
-			my $ms_size = $12;
+			my $ms_val = $8;
+			my $ms_size = $14;
 
 			if ($ms_size =~ /^(0x|)0$/i) {
 				ERROR("MEMSET",
-- 
1.7.10.4

