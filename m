Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074Ab3HJOkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 10:40:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45108 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933907Ab3HJOkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 10:40:13 -0400
Message-ID: <1376145607.2083.15.camel@joe-AO722>
Subject: [PATCH next]  checkpatch: Fix perl version 5.12 and earlier
 incompatibility
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 10 Aug 2013 07:40:07 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 203489a33 ("checkpatch: add --types option
to report only specific message types") uses a
perl syntax introduced in perl version 5.14.

Use the backward compatible perl syntax instead.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3ba2db6..51ee331 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -174,9 +174,9 @@ sub hash_save_array_words {
 sub hash_show_words {
 	my ($hashRef, $prefix) = @_;
 
-	if ($quiet == 0 && keys $hashRef) {
+	if ($quiet == 0 && keys %{$hashRef}) {
 		print "NOTE: $prefix message types:";
-		foreach my $word (sort keys $hashRef) {
+		foreach my $word (sort keys %{$hashRef}) {
 			print " $word";
 		}
 		print "\n\n";



