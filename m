Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaDHNZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:25:22 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:45653 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaDHNZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:25:19 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] checkpatch: skip directories in file checking mode
Date: Tue,  8 Apr 2014 08:25:05 -0500
Message-Id: <1396963505-11119-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396963505-11119-1-git-send-email-robherring2@gmail.com>
References: <1396963505-11119-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Running checkpatch.pl on a list of files using a wildcard will exit if
a directory is encountered. For example:

$ scripts/checkpatch.pl -f arch/*
diff: arch/alpha/null: No such file or directory

The correct operation is arch/Kconfig should be checked. Fix this by
skipping files which are not regular files.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0e960b1..b646b95 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -552,6 +552,7 @@ my $vname;
 for my $filename (@ARGV) {
 	my $FILE;
 	if ($file) {
+		next if (!(-f $filename));
 		open($FILE, '-|', "diff -u /dev/null $filename") ||
 			die "$P: $filename: diff failed - $!\n";
 	} elsif ($filename eq '-') {
-- 
1.9.1

