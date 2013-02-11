Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3BKT3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:29:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54883 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759564Ab3BKT3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:29:36 -0500
Message-ID: <1360610974.28491.6.camel@joe-AO722>
Subject: [PATCH] scripts: Remove Lindent and suggestions to use it
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org, apw@canonical.com,
        Solomon Peachy <pizza@shaftnet.org>
Date: Mon, 11 Feb 2013 11:29:34 -0800
In-Reply-To: <20130211190741.GC3123@shaftnet.org>
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
	 <1360355527-12159-2-git-send-email-pizza@shaftnet.org>
	 <1360372559.13487.14.camel@joe-AO722> <20130211190741.GC3123@shaftnet.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lindent had its last good day more than a decade ago.
Time to put it down.

Remove suggestions to use it too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/CodingStyle              | 15 ---------------
 Documentation/hwmon/submitting-patches |  5 -----
 scripts/Lindent                        | 18 ------------------
 3 files changed, 38 deletions(-)
 delete mode 100755 scripts/Lindent

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index e00b8f0..020d1b6 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -514,21 +514,6 @@ values.  To do the latter, you can stick the following in your .emacs file:
 This will make emacs go better with the kernel coding style for C
 files below ~/src/linux-trees.
 
-But even if you fail in getting emacs to do sane formatting, not
-everything is lost: use "indent".
-
-Now, again, GNU indent has the same brain-dead settings that GNU emacs
-has, which is why you need to give it a few command line options.
-However, that's not too bad, because even the makers of GNU indent
-recognize the authority of K&R (the GNU people aren't evil, they are
-just severely misguided in this matter), so you just give indent the
-options "-kr -i8" (stands for "K&R, 8 character indents"), or use
-"scripts/Lindent", which indents in the latest style.
-
-"indent" has a lot of options, and especially when it comes to comment
-re-formatting you may want to take a look at the man page.  But
-remember: "indent" is not a fix for bad programming.
-
 
 		Chapter 10: Kconfig configuration files
 
diff --git a/Documentation/hwmon/submitting-patches b/Documentation/hwmon/submitting-patches
index 843751c..449d630 100644
--- a/Documentation/hwmon/submitting-patches
+++ b/Documentation/hwmon/submitting-patches
@@ -49,11 +49,6 @@ increase the chances of your change being accepted.
 3. New drivers
 --------------
 
-* Running your patch or driver file(s) through checkpatch does not mean its
-  formatting is clean. If unsure about formatting in your new driver, run it
-  through Lindent. Lindent is not perfect, and you may have to do some minor
-  cleanup, but it is a good start.
-
 * Consider adding yourself to MAINTAINERS.
 
 * Document the driver in Documentation/hwmon/<driver_name>.
diff --git a/scripts/Lindent b/scripts/Lindent
deleted file mode 100755
index 9c4b3e2..0000000
--- a/scripts/Lindent
+++ /dev/null
@@ -1,18 +0,0 @@
-#!/bin/sh
-PARAM="-npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1"
-RES=`indent --version`
-V1=`echo $RES | cut -d' ' -f3 | cut -d'.' -f1`
-V2=`echo $RES | cut -d' ' -f3 | cut -d'.' -f2`
-V3=`echo $RES | cut -d' ' -f3 | cut -d'.' -f3`
-if [ $V1 -gt 2 ]; then
-  PARAM="$PARAM -il0"
-elif [ $V1 -eq 2 ]; then
-  if [ $V2 -gt 2 ]; then
-    PARAM="$PARAM -il0";
-  elif [ $V2 -eq 2 ]; then
-    if [ $V3 -ge 10 ]; then
-      PARAM="$PARAM -il0"
-    fi
-  fi
-fi
-indent $PARAM "$@"
-- 
1.8.1.2.459.gbcd45b4.dirty



