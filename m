Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab3IBWOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 18:14:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49886 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753909Ab3IBWOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 18:14:48 -0400
Message-ID: <1378160086.1953.129.camel@joe-AO722>
Subject: [PATCH] checkpatch: Report missing spaces around trigraphs with
 --strict
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Mon, 02 Sep 2013 15:14:46 -0700
In-Reply-To: <5224EF32.5060104@roeck-us.net>
References: <9976.1378132260@warthog.procyon.org.uk>
	 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
	 <20130902181856.GB29787@leaf> <20130902153945.6d7e510c@samsung.com>
	 <1378148367.1953.98.camel@joe-AO722> <20130902195056.GB32628@leaf>
	 <5224EF32.5060104@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spaces around trigraphs are specified by CodingStyle
but checkpatch is currently silent about them because
there are many current instances without them.

Make missing spaces around trigraphs a --strict message.

Signed-off-by: Joe Perches <joe@perches.com>
---
> Oddly enough, the opposite is true as well. 3.1, spaces around binary
> and ternary operators, is for example not enforced, presumably because
> it would generate too many positives. Since I like that rule, I have
> my private version of checkpatch.pl which does check for it. After all,
> it _is_ a CodingStyle rule.

 scripts/checkpatch.pl | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9bb056c..bb34c11 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2817,7 +2817,7 @@ sub process {
 				\+=|-=|\*=|\/=|%=|\^=|\|=|&=|
 				=>|->|<<|>>|<|>|=|!|~|
 				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%|
-				\?|:
+				\?:|\?|:
 			}x;
 			my @elements = split(/($ops|;)/, $opline);
 
@@ -3040,15 +3040,13 @@ sub process {
 					    	$ok = 1;
 					}
 
-					# Ignore ?:
-					if (($opv eq ':O' && $ca =~ /\?$/) ||
-					    ($op eq '?' && $cc =~ /^:/)) {
-					    	$ok = 1;
-					}
-
+					# messages are ERROR, but ?: are CHK
 					if ($ok == 0) {
-						if (ERROR("SPACING",
-							  "spaces required around that '$op' $at\n" . $hereptr)) {
+						my $msg_type = \&ERROR;
+						$msg_type = \&CHK if (($op eq '?:' || $op eq '?' || $op eq ':') && $ctx =~ /VxV/);
+
+						if (&{$msg_type}("SPACING",
+								 "spaces required around that '$op' $at\n" . $hereptr)) {
 							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;


