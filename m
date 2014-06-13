Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaFMGyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:54:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38083 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaFMGyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:54:05 -0400
Date: Fri, 13 Jun 2014 09:53:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: [patch] checkpatch: warn on missing spaces in broken up quoted
 strings
Message-ID: <20140613065346.GA28134@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch already complains when people break up quoted strings but
it's still pretty common.  One mistake that people often make is they
leave out the space character between the two strings.

This check adds 453 new warnings.  There very few false positives, here
is what they look like:

1) Most of the false positives are in crypto/testmgr.h where they just
   want a 10x10 block of sample text and don't care about the content.
2) There one commented place like this:
  "das08-aoh"
  "das08-aol"
3) There is one place which breaks the alphabet at the lower and upper
   case boundary.
4) There is one person who broke quoted strings at the 80 character mark
   without considering the content (that's not really a false positive,
   now that I think about it).

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18e..c50eee2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4009,6 +4009,12 @@ sub process {
 			}
 		}
 
+# check for missing a space in a string concatination
+        if ($prevrawline =~ /[^\\][a-zA-Z]"$/ && $rawline =~ /^\+[\t ]+"[a-zA-Z]/) {
+            WARN('MISSING_SPACE',
+                 "break quoted strings at a space character\n" . $hereprev);
+        }
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
