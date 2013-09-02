Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab3IBTkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 15:40:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54540 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757074Ab3IBTku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 15:40:50 -0400
Message-ID: <1378150847.1953.106.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add warning about submitting patches using
 --file
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        David Howells <dhowells@redhat.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 02 Sep 2013 12:40:47 -0700
In-Reply-To: <20130902181856.GB29787@leaf>
References: <9976.1378132260@warthog.procyon.org.uk>
	 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
	 <20130902181856.GB29787@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a message describing the lack of value in using
--file to generate patches.

Exclude files in staging from this message.

A similar message was removed by commit cf655043d4b
("update checkpatch.pl to version 0.15")

Signed-off-by: Joe Perches <joe@perches.com>
---

Maybe this sort of wordsmithing is valuable.

 scripts/checkpatch.pl | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9bb056c..f788a14 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4280,6 +4280,19 @@ $vname has style problems, please review.
 If any of these errors are false positives, please report
 them to the maintainer, see CHECKPATCH in MAINTAINERS.
 EOM
+		if ($file && $realfile !~ m@\bstaging/@) {
+			print << "EOM";
+
+WARNING: When using --file mode, do not send patches that just make
+whitespace or formatting changes unless more significant changes are
+also made for other reasons in another patch.
+
+Patches that are just code style changes have a real cost.
+
+These sort of patches can cause rejects with other changes and are
+thought of by many maintainers as more harmful and tiresome than useful.
+EOM
+		}
 	}
 
 	return $clean;


