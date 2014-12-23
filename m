Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbaLWQcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:32:24 -0500
Received: from tex.lwn.net ([70.33.254.29]:51372 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213AbaLWQcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:32:19 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/7] Docs: Remove "tips and tricks" from SubmittingPatches
Date: Tue, 23 Dec 2014 09:32:01 -0700
Message-Id: <1419352327-4517-2-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419352327-4517-1-git-send-email-corbet@lwn.net>
References: <1419352327-4517-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This section was just a weird collection of stuff that is better found
elsewhere.  The "coding style" section somewhat duplicated the previous
coding style section; the useful information there has been collected into
a single place.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/SubmittingPatches | 117 ++++++++--------------------------------
 1 file changed, 21 insertions(+), 96 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 1fa1caa198eb..8f416a2b409f 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -193,17 +193,33 @@ then only post say 15 or so at a time and wait for review and integration.
 
 
 
-4) Style check your changes.
+4) Style-check your changes.
+----------------------------
 
 Check your patch for basic style violations, details of which can be
 found in Documentation/CodingStyle.  Failure to do so simply wastes
 the reviewers time and will get your patch rejected, probably
 without even being read.
 
-At a minimum you should check your patches with the patch style
-checker prior to submission (scripts/checkpatch.pl).  You should
-be able to justify all violations that remain in your patch.
+One significant exception is when moving code from one file to
+another -- in this case you should not modify the moved code at all in
+the same patch which moves it.  This clearly delineates the act of
+moving the code and your changes.  This greatly aids review of the
+actual differences and allows tools to better track the history of
+the code itself.
+
+Check your patches with the patch style checker prior to submission
+(scripts/checkpatch.pl).  Note, though, that the style checker should be
+viewed as a guide, not as a replacement for human judgment.  If your code
+looks better with a violation then its probably best left alone.
 
+The checker reports at three levels:
+ - ERROR: things that are very likely to be wrong
+ - WARNING: things requiring careful review
+ - CHECK: things requiring thought
+
+You should be able to justify all violations that remain in your
+patch.
 
 
 5) Select e-mail destination.
@@ -684,100 +700,9 @@ new/deleted or renamed files.
 With rename detection, the statistics are rather different [...]
 because git will notice that a fair number of the changes are renames.
 
------------------------------------
-SECTION 2 - HINTS, TIPS, AND TRICKS
------------------------------------
-
-This section lists many of the common "rules" associated with code
-submitted to the kernel.  There are always exceptions... but you must
-have a really good reason for doing so.  You could probably call this
-section Linus Computer Science 101.
-
-
-
-1) Read Documentation/CodingStyle
-
-Nuff said.  If your code deviates too much from this, it is likely
-to be rejected without further review, and without comment.
-
-One significant exception is when moving code from one file to
-another -- in this case you should not modify the moved code at all in
-the same patch which moves it.  This clearly delineates the act of
-moving the code and your changes.  This greatly aids review of the
-actual differences and allows tools to better track the history of
-the code itself.
-
-Check your patches with the patch style checker prior to submission
-(scripts/checkpatch.pl).  The style checker should be viewed as
-a guide not as the final word.  If your code looks better with
-a violation then its probably best left alone.
-
-The checker reports at three levels:
- - ERROR: things that are very likely to be wrong
- - WARNING: things requiring careful review
- - CHECK: things requiring thought
-
-You should be able to justify all violations that remain in your
-patch.
-
-
-
-2) #ifdefs are ugly
-
-Code cluttered with ifdefs is difficult to read and maintain.  Don't do
-it.  Instead, put your ifdefs in a header, and conditionally define
-'static inline' functions, or macros, which are used in the code.
-Let the compiler optimize away the "no-op" case.
-
-Simple example, of poor code:
-
-	dev = alloc_etherdev (sizeof(struct funky_private));
-	if (!dev)
-		return -ENODEV;
-	#ifdef CONFIG_NET_FUNKINESS
-	init_funky_net(dev);
-	#endif
-
-Cleaned-up example:
-
-(in header)
-	#ifndef CONFIG_NET_FUNKINESS
-	static inline void init_funky_net (struct net_device *d) {}
-	#endif
-
-(in the code itself)
-	dev = alloc_etherdev (sizeof(struct funky_private));
-	if (!dev)
-		return -ENODEV;
-	init_funky_net(dev);
-
-
-
-3) 'static inline' is better than a macro
-
-Static inline functions are greatly preferred over macros.
-They provide type safety, have no length limitations, no formatting
-limitations, and under gcc they are as cheap as macros.
-
-Macros should only be used for cases where a static inline is clearly
-suboptimal [there are a few, isolated cases of this in fast paths],
-or where it is impossible to use a static inline function [such as
-string-izing].
-
-'static inline' is preferred over 'static __inline__', 'extern inline',
-and 'extern __inline__'.
-
-
-
-4) Don't over-design.
-
-Don't try to anticipate nebulous future cases which may or may not
-be useful:  "Make it as simple as you can, and no simpler."
-
-
 
 ----------------------
-SECTION 3 - REFERENCES
+SECTION 2 - REFERENCES
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-- 
2.1.0

