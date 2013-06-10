Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3FJWVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:21:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46219 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754085Ab3FJWVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:21:43 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] checkpatch: Reduce false positive rate of "complex macros"
Date: Mon, 10 Jun 2013 15:20:44 -0700
Message-Id: <8cc09d6a343561171b50099d49deb0bfa54935ae.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow "#define foo struct.member" without bleating a warning.

This also allows "#define foo bar.baz->qux" and so on.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f4e247b2..93b8e66 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3041,7 +3041,7 @@ sub process {
 			if ($dstat ne '' &&
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
-			    $dstat !~ /^[!~-]?(?:$Ident|$Constant)$/ &&		# 10 // foo() // !foo // ~foo // -foo
+			    $dstat !~ /^[!~-]?(?:$Lval|$Constant)$/ &&		# 10 // foo() // !foo // ~foo // -foo // foo->bar // foo.bar->baz
 			    $dstat !~ /^'X'$/ &&					# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
-- 
1.8.1.2.459.gbcd45b4.dirty

