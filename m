Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3C1Leu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:34:50 -0400
Received: from chicago.guarana.org ([192.210.136.102]:53911 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3C1Les (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:34:48 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Mar 2013 07:34:48 EDT
Date: Thu, 28 Mar 2013 22:25:04 +1100
From: Kevin Easton <kevin@guarana.org>
To: mtk.manpages@gmail.com
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] clone.2, execve.2: Describe interaction of execve(2) and
 CLONE_FILES
Message-ID: <20130328112504.GA16163@chicago.guarana.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Michael,

This very small patch against man-pages-3.50 adds a description of the
way in which a shared file descriptor table, as created by the
CLONE_FILES flag of clone(2), is unshared when a process calls execve(2).

It's easy to see this from the source - there's an unshare_files()
call early in do_execve_common().

    - Kevin

diff -urN man-pages-3.50.orig/man2/clone.2 man-pages-3.50/man2/clone.2
--- man-pages-3.50.orig/man2/clone.2    2013-03-15 18:17:35.000000000 +1100
+++ man-pages-3.50/man2/clone.2 2013-03-28 21:50:04.745932956 +1100
@@ -180,6 +180,9 @@
 .BR fcntl (2)
 .B F_SETFD
 operation), the other process is also affected.
+If a process sharing a file descriptor table calls
+.BR execve (2),
+its file descriptor table is duplicated (unshared).

 If
 .B CLONE_FILES
diff -urN man-pages-3.50.orig/man2/execve.2 man-pages-3.50/man2/execve.2
--- man-pages-3.50.orig/man2/execve.2   2013-03-15 18:17:35.000000000 +1100
+++ man-pages-3.50/man2/execve.2    2013-03-28 22:02:56.793844616 +1100
@@ -204,6 +204,11 @@
 .B SIGCHLD
 (see
 .BR clone (2)).
+.IP *
+The file descriptor table is unshared, undoing the effect of the
+.B CLONE_FILES
+flag of
+.BR clone (2).
 .PP
 Note the following further points:
 .IP * 3


--nFreZHaLTZJo0R7j
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="clone-files.diff"

diff -urN man-pages-3.50.orig/man2/clone.2 man-pages-3.50/man2/clone.2
--- man-pages-3.50.orig/man2/clone.2	2013-03-15 18:17:35.000000000 +1100
+++ man-pages-3.50/man2/clone.2	2013-03-28 21:50:04.745932956 +1100
@@ -180,6 +180,9 @@
 .BR fcntl (2)
 .B F_SETFD
 operation), the other process is also affected.
+If a process sharing a file descriptor table calls
+.BR execve (2),
+its file descriptor table is duplicated (unshared).
 
 If
 .B CLONE_FILES
diff -urN man-pages-3.50.orig/man2/execve.2 man-pages-3.50/man2/execve.2
--- man-pages-3.50.orig/man2/execve.2	2013-03-15 18:17:35.000000000 +1100
+++ man-pages-3.50/man2/execve.2	2013-03-28 22:02:56.793844616 +1100
@@ -204,6 +204,11 @@
 .B SIGCHLD
 (see
 .BR clone (2)).
+.IP *
+The file descriptor table is unshared, undoing the effect of the
+.B CLONE_FILES
+flag of
+.BR clone (2).
 .PP
 Note the following further points:
 .IP * 3

--nFreZHaLTZJo0R7j--
