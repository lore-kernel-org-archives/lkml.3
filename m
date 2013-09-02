Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab3IBXya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 19:54:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41592 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759051Ab3IBXy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 19:54:29 -0400
Message-ID: <1378166065.1953.134.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Report missing spaces around trigraphs with
 --strict
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Mon, 02 Sep 2013 16:54:25 -0700
In-Reply-To: <20130902231514.GA1163@leaf>
References: <9976.1378132260@warthog.procyon.org.uk>
	 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
	 <20130902181856.GB29787@leaf> <20130902153945.6d7e510c@samsung.com>
	 <1378148367.1953.98.camel@joe-AO722> <20130902195056.GB32628@leaf>
	 <5224EF32.5060104@roeck-us.net> <1378160086.1953.129.camel@joe-AO722>
	 <20130902231514.GA1163@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> would you mind looking at why
> it gives a false positive for spaces around '*' on my recent patch at
> http://mid.gmane.org/20130901234251.GB25057@leaf ?  It appears to
> mistake the '*' of a pointer for a multiply.

Looks like checkpatch thinks this should be a multiplication.

Try this:
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9bb056c..e421b5e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3005,7 +3005,7 @@ sub process {
 					 $op eq '*' or $op eq '/' or
 					 $op eq '%')
 				{
-					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
+					if ($ctx =~ /Wx[^WCEB]|[^WCE]xW/) {
 						if (ERROR("SPACING",
 							  "need consistent spacing around '$op' $at\n" . $hereptr)) {
 							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";


