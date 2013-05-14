Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab3ENQq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:46:56 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45713 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab3ENQqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:46:55 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] checkpatch: avoid warning on page flag acessors
Date: Tue, 14 May 2013 09:45:51 -0700
Message-Id: <1368549951-1170-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051416-5806-0000-0000-000021224AF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using Page*() triggers a camelcase warning, but shouldn't.

Introduced by be987d9f80354e2e919926349282facd74992f90, which added the
other Page flag users.

Pipe ('|') at the end of a grouping doesn't cause the grouping to match
an emtpy string, use ? after the grouping instead to get the desired
behavior.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b954de5..ee24026 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2939,7 +2939,7 @@ sub process {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
-			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+			    $var !~ /"^(?:Clear|Set|TestClear|TestSet)?Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",
-- 
1.8.2.2

