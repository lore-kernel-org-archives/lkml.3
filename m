Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaLWQdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:33:35 -0500
Received: from tex.lwn.net ([70.33.254.29]:51377 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbaLWQcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:32:20 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/7] Docs: Update recipient information in SubmittingPatches
Date: Tue, 23 Dec 2014 09:32:03 -0700
Message-Id: <1419352327-4517-4-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419352327-4517-1-git-send-email-corbet@lwn.net>
References: <1419352327-4517-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SubmittingPatches had two sections on selecting recipients; both were
showing their age.  Unify them into a single section that more closely
reflects how we do things now.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/SubmittingPatches | 107 ++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 53 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 230a3b892db6..e169c6ca5243 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -250,68 +250,68 @@ You should be able to justify all violations that remain in your
 patch.
 
 
-5) Select e-mail destination.
-
-Look through the MAINTAINERS file and the source code, and determine
-if your change applies to a specific subsystem of the kernel, with
-an assigned maintainer.  If so, e-mail that person.  The script
-scripts/get_maintainer.pl can be very useful at this step.
-
-If no maintainer is listed, or the maintainer does not respond, send
-your patch to the primary Linux kernel developer's mailing list,
-linux-kernel@vger.kernel.org.  Most kernel developers monitor this
-e-mail list, and can comment on your changes.
-
+5) Select the recipients for your patch.
+----------------------------------------
+
+You should always copy the appropriate subsystem maintainer(s) on any patch
+to code that they maintain; look through the MAINTAINERS file and the
+source code revision history to see who those maintainers are.  The
+script scripts/get_maintainer.pl can be very useful at this step.  If you
+cannot find a maintainer for the subsystem your are working on, Andrew
+Morton (akpm@linux-foundation.org) serves as a maintainer of last resort.
+
+You should also normally choose at least one mailing list to receive a copy
+of your patch set.  linux-kernel@vger.kernel.org functions as a list of
+last resort, but the volume on that list has caused a number of developers
+to tune it out.  Look in the MAINTAINERS file for a subsystem-specific
+list; your patch will probably get more attention there.  Please do not
+spam unrelated lists, though.
+
+Many kernel-related lists are hosted on vger.kernel.org; you can find a
+list of them at http://vger.kernel.org/vger-lists.html.  There are
+kernel-related lists hosted elsewhere as well, though.
 
 Do not send more than 15 patches at once to the vger mailing lists!!!
 
-
 Linus Torvalds is the final arbiter of all changes accepted into the
 Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>. 
-He gets a lot of e-mail, so typically you should do your best to -avoid-
-sending him e-mail. 
-
-Patches which are bug fixes, are "obvious" changes, or similarly
-require little discussion should be sent or CC'd to Linus.  Patches
-which require discussion or do not have a clear advantage should
-usually be sent first to linux-kernel.  Only after the patch is
-discussed should the patch then be submitted to Linus.
-
-
+He gets a lot of e-mail, and, at this point, very few patches go through
+Linus directly, so typically you should do your best to -avoid-
+sending him e-mail.
 
-6) Select your CC (e-mail carbon copy) list.
+If you have a patch that fixes an exploitable security bug, send that patch
+to security@kernel.org.  For severe bugs, a short embargo may be considered
+to allow distrbutors to get the patch out to users; in such cases,
+obviously, the patch should not be sent to any public lists.
 
-Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.
+Patches that fix a severe bug in a released kernel should be directed
+toward the stable maintainers by putting a line like this:
 
-Other kernel developers besides Linus need to be aware of your change,
-so that they may comment on it and offer code review and suggestions.
-linux-kernel is the primary Linux kernel developer mailing list.
-Other mailing lists are available for specific subsystems, such as
-USB, framebuffer devices, the VFS, the SCSI subsystem, etc.  See the
-MAINTAINERS file for a mailing list that relates specifically to
-your change.
+  Cc: stable@vger.kernel.org
 
-Majordomo lists of VGER.KERNEL.ORG at:
-	<http://vger.kernel.org/vger-lists.html>
+into your patch.
 
-If changes affect userland-kernel interfaces, please send
-the MAN-PAGES maintainer (as listed in the MAINTAINERS file)
-a man-pages patch, or at least a notification of the change,
-so that some information makes its way into the manual pages.
+Note, however, that some subsystem maintainers want to come to their own
+conclusions on which patches should go to the stable trees.  The networking
+maintainer, in particular, would rather not see individual developers
+adding lines like the above to their patches.
 
-Even if the maintainer did not respond in step #5, make sure to ALWAYS
-copy the maintainer when you change their code.
+If changes affect userland-kernel interfaces, please send the MAN-PAGES
+maintainer (as listed in the MAINTAINERS file) a man-pages patch, or at
+least a notification of the change, so that some information makes its way
+into the manual pages.  User-space API changes should also be copied to
+linux-api@vger.kernel.org. 
 
 For small patches you may want to CC the Trivial Patch Monkey
 trivial@kernel.org which collects "trivial" patches. Have a look
 into the MAINTAINERS file for its current manager.
 Trivial patches must qualify for one of the following rules:
  Spelling fixes in documentation
- Spelling fixes which could break grep(1)
+ Spelling fixes for errors which could break grep(1)
  Warning fixes (cluttering with useless warnings is bad)
  Compilation fixes (only if they are actually correct)
  Runtime fixes (only if they actually fix things)
- Removing use of deprecated functions/macros (eg. check_region)
+ Removing use of deprecated functions/macros
  Contact detail and documentation fixes
  Non-portable code replaced by portable code (even in arch-specific,
  since people copy, as long as it's trivial)
@@ -320,7 +320,7 @@ Trivial patches must qualify for one of the following rules:
 
 
 
-7) No MIME, no links, no compression, no attachments.  Just plain text.
+6) No MIME, no links, no compression, no attachments.  Just plain text.
 
 Linus and other kernel developers need to be able to read and comment
 on the changes you are submitting.  It is important for a kernel
@@ -343,7 +343,7 @@ you to re-send them using MIME.
 See Documentation/email-clients.txt for hints about configuring
 your e-mail client so that it sends your patches untouched.
 
-8) E-mail size.
+7) E-mail size.
 
 When sending patches to Linus, always follow step #7.
 
@@ -354,7 +354,7 @@ server, and provide instead a URL (link) pointing to your patch.
 
 
 
-9) Name your kernel version.
+8) Name your kernel version.
 
 It is important to note, either in the subject line or in the patch
 description, the kernel version to which this patch applies.
@@ -364,7 +364,7 @@ Linus will not apply it.
 
 
 
-10) Don't get discouraged.  Re-submit.
+9) Don't get discouraged.  Re-submit.
 
 After you have submitted your change, be patient and wait.  If Linus
 likes your change and applies it, it will appear in the next version
@@ -390,7 +390,7 @@ When in doubt, solicit comments on linux-kernel mailing list.
 
 
 
-11) Include PATCH in the subject
+10) Include PATCH in the subject
 
 Due to high e-mail traffic to Linus, and to linux-kernel, it is common
 convention to prefix your subject line with [PATCH].  This lets Linus
@@ -399,7 +399,7 @@ e-mail discussions.
 
 
 
-12) Sign your work
+11) Sign your work
 
 To improve tracking of who did what, especially with patches that can
 percolate to their final resting place in the kernel through several
@@ -494,7 +494,7 @@ tracking your trees, and to people trying to troubleshoot bugs in your
 tree.
 
 
-13) When to use Acked-by: and Cc:
+12) When to use Acked-by: and Cc:
 
 The Signed-off-by: tag indicates that the signer was involved in the
 development of the patch, or that he/she was in the patch's delivery path.
@@ -525,7 +525,7 @@ person it names.  This tag documents that potentially interested parties
 have been included in the discussion
 
 
-14) Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
+13) Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
 
 The Reported-by tag gives credit to people who find bugs and report them and it
 hopefully inspires them to help us again in the future.  Please note that if
@@ -585,7 +585,7 @@ which stable kernel versions should receive your fix. This is the preferred
 method for indicating a bug fixed by the patch. See #2 above for more details.
 
 
-15) The canonical patch format
+14) The canonical patch format
 ------------------------------
 
 This section describes how the patch itself should be formatted.  Note
@@ -599,7 +599,8 @@ The canonical patch subject line is:
 
 The canonical patch message body contains the following:
 
-  - A "from" line specifying the patch author.
+  - A "from" line specifying the patch author (only needed if the person
+    sending the patch is not the author).
 
   - An empty line.
 
@@ -706,7 +707,7 @@ See more details on the proper patch format in the following
 references.
 
 
-16) Sending "git pull" requests
+15) Sending "git pull" requests
 -------------------------------
 
 If you have a series of patches, it may be most convenient to have the
-- 
2.1.0

