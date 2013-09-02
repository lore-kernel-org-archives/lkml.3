Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab3IBQVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:21:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59069 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758204Ab3IBQVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:21:45 -0400
Message-ID: <1378138904.1953.72.camel@joe-AO722>
Subject: [PATCH] checkpatch: Make extern in .h prototypes quieter.
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org
Date: Mon, 02 Sep 2013 09:21:44 -0700
In-Reply-To: <9606.1378129893@warthog.procyon.org.uk>
References: <9606.1378129893@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of extern in .h files is a bit contentious.

Make it emitted only when --strict is used on the
command-line.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9bb056c..13165ea 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3927,8 +3927,8 @@ sub process {
 # check for new externs in .h files.
 		if ($realfile =~ /\.h$/ &&
 		    $line =~ /^\+\s*(extern\s+)$Type\s*$Ident\s*\((?!\s*\*)/) {
-			if (WARN("AVOID_EXTERNS",
-				 "extern prototypes should be avoided in .h files\n" . $herecurr) &&
+			if (CHK("AVOID_EXTERNS",
+				"extern prototypes should be avoided in .h files\n" . $herecurr) &&
 			    $fix) {
 				$fixed[$linenr - 1] =~ s/(.*)\bextern\s+(.*)/$1$2/;
 			}


