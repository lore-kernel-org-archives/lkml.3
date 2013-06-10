Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3FJWVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:21:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56142 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752907Ab3FJWVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:21:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] checkpatch: Remove quote from CamelCase test
Date: Mon, 10 Jun 2013 15:20:39 -0700
Message-Id: <641477a66bf1fe43f8fabdeb4a04b92fc354d151.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit be987d9f80 ("checkpatch: improve CamelCase test for Page")
added it but it shouldn't be there.  Must have been my fault.

Make sure that the tested variable doesn't contain a constant.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6185eb6..2f61b5c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2949,9 +2949,9 @@ sub process {
 			}
 
 #CamelCase
-			if ($var !~ /$Constant/ &&
+			if ($var !~ /^$Constant$/ &&
 			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
-			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				CHK("CAMELCASE",
-- 
1.8.1.2.459.gbcd45b4.dirty

