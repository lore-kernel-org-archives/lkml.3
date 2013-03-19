Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016Ab3CSWj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:39:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46209 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933625Ab3CSWj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:39:57 -0400
Message-ID: <1363732795.16270.23.camel@joe-AO722>
Subject: [PATCH] checkpatch: Complain about executable files
From: Joe Perches <joe@perches.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Tue, 19 Mar 2013 15:39:55 -0700
In-Reply-To: <1363240339-18327-1-git-send-email-sboyd@codeaurora.org>
References: <1363240339-18327-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complain about files with an executable bit set that are
not in a scripts/ directory and are not type
.pl, .py, .awk, or .sh

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..f119c84 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1576,7 +1576,8 @@ sub process {
 # Check for incorrect file permissions
 		if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
 			my $permhere = $here . "FILE: $realfile\n";
-			if ($realfile =~ /(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl)$/) {
+			if ($realfile !~ m@scripts/@ &&
+			    $realfile !~ /\.(py|pl|awk|sh)$/) {
 				ERROR("EXECUTE_PERMISSIONS",
 				      "do not set execute permissions for source files\n" . $permhere);
 			}


