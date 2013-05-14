Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3ENRRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:17:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49771 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab3ENRRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:17:50 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v4] checkpatch: avoid warning on page flag acessors
Date: Tue, 14 May 2013 10:17:30 -0700
Message-Id: <1368551850-7513-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368549951-1170-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368549951-1170-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051417-7182-0000-0000-000006AF7BA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using Page*() triggers a camelcase warning, but shouldn't.

be987d9f80354e2e919926349282facd74992f90 added a spurious '"' (double
quote) breaking the regex.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---
And using sha1s in format-patch means I have to actually copy the new ones. (Again, sorry).

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b954de5..d2fe01d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2939,7 +2939,7 @@ sub process {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
-			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",
-- 
1.8.2.2

