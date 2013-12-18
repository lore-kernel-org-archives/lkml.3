Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3LRDCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:02:12 -0500
Received: from [65.182.180.190] ([65.182.180.190]:43992 "EHLO
	mxadeneo.adeneo-embedded.us" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751240Ab3LRDCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:02:11 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2013 22:02:11 EST
From: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
To: <linux-kernel@vger.kernel.org>
CC: <joe@perches.com>, Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
Subject: [PATCH] checkpatch.pl: Fix wrong curly bracket position reporting
Date: Tue, 17 Dec 2013 18:56:52 -0800
Message-ID: <1387335412-8694-1-git-send-email-jtheou@adeneo-embedded.us>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.20.56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes wrong curly bracket position reporting when function
declarations have only one void argument.

Missing error (ERROR: space required before the open brace '{') on this
situation :

int foo(void){
	...
}

Signed-off-by: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8f3aecd..3a18c5e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3159,7 +3159,7 @@ sub process {
 ## 		}
 
 #need space before brace following if, while, etc
-		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
+		if (($line =~ /\(.*\){/ && ($line =~ /\(void\){/ || $line !~ /\($Type\){/)) ||
 		    $line =~ /do{/) {
 			if (ERROR("SPACING",
 				  "space required before the open brace '{'\n" . $herecurr) &&
-- 
1.8.4.2

