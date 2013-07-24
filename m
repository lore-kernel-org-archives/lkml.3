Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3GXTY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:24:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59166 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753070Ab3GXTYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:24:25 -0400
Message-ID: <1374693864.18818.24.camel@joe-AO722>
Subject: [PATCH] checkpatch: Check for duplicate signatures
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
        Won Kang <wonkang@gctsemi.com>
Date: Wed, 24 Jul 2013 12:24:24 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit a warning when a signature is used more than once.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5cfef19..6918517 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1532,6 +1532,7 @@ sub process {
 	my %suppress_export;
 	my $suppress_statement = 0;
 
+	my %signatures = ();
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -1781,6 +1782,17 @@ sub process {
 					     "email address '$email' might be better as '$suggested_email$comment'\n" . $herecurr);
 				}
 			}
+
+# Check for duplicate signatures
+			my $sig_nospace = $line;
+			$sig_nospace =~ s/\s//g;
+			$sig_nospace = lc($sig_nospace);
+			if (defined $signatures{$sig_nospace}) {
+				WARN("BAD_SIGN_OFF",
+				     "Duplicate signature\n" . $herecurr);
+			} else {
+				$signatures{$sig_nospace} = 1;
+			}
 		}
 
 # Check for wrappage within a valid hunk of the file


