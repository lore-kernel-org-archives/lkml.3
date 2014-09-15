Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaIOPNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:13:06 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52539 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaIOPNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:13:04 -0400
From: Roman Pen <r.peniaev@gmail.com>
Cc: Roman Pen <r.peniaev@gmail.com>, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] checkpatch: fix perl v5.20 warning: useless use of greediness modifier
Date: Tue, 16 Sep 2014 00:12:50 +0900
Message-Id: <1410793970-22778-1-git-send-email-r.peniaev@gmail.com>
X-Mailer: git-send-email 2.0.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on my perl v5.20 I got:
  Useless use of greediness modifier '+' in regex; marked by
  <-- HERE in m/(^\+.*) {8,8}+ <-- HERE \t/ at ./scripts/checkpatch.pl line 2427.

greediness modifier '+' in construction '\s{8,8}+' does not make
any sense, because we already specify how many chars do we expect.

Also we can avoid second ',8' and use simple '\s{8}'.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4d08b39..ccd3234 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2424,7 +2424,7 @@ sub process {
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
 				while ($fixed[$fixlinenr] =~
-					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
+					   s/(^\+.*) {8}\t/$1\t\t/) {}
 				while ($fixed[$fixlinenr] =~
 					   s/(^\+.*) +\t/$1\t/) {}
 			}
-- 
2.0.0

