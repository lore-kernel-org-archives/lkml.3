Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaHVEN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:13:28 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64267 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaHVEN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:13:27 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] checkpatch.pl: New instances of ENOSYS are errors
Date: Thu, 21 Aug 2014 23:13:20 -0500
Message-Id: <973469ca58b32c73c7c8ca68065e22a18574e112.1408680621.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ENOSYS means that a nonexistent system call was called.  We have a
bad habit of using it for things like invalid operations on
otherwise valid syscalls.  We should avoid this in new code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Pervasive incorrect usage of ENOSYS came up at the kernel summit ABI
review discussion.  Let's see if checkpatch can help.

 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 182be0f..5749a44 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2372,6 +2372,15 @@ sub process {
 			     "Using $1 is unnecessary\n" . $herecurr);
 		}
 
+# ENOSYS means "bad syscall nr" and nothing else
+# (note that this doesn't run on assembly files, so entry*.S is okay)
+		if ($line =~ /ENOSYS/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("ENOSYS",
+			      "ENOSYS means 'invalid syscall nr' and nothing else\n" .
+			      "       (ignore if this really is syscall entry code)\n" . $herevet);
+		}
+
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
-- 
1.9.3

