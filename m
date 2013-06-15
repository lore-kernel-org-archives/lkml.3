Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3FOQTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 12:19:19 -0400
Received: from mout.gmx.net ([212.227.15.18]:52044 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab3FOQTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 12:19:18 -0400
From: xypron.glpk@gmx.de
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Enable fanotify API by default.
Date: Sat, 15 Jun 2013 18:17:27 +0200
Message-Id: <1371313047-17753-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:ubQWyU2/OPJekSInY6x33yMNCO9eA5SsD56KfpVC33UXfmpVBnP
 51ROgSHz8ji1I7YPvwJQPTkosV+EtsFVESOx03URIGiNzi7K9jatAz+0Ftcg1XnJokoYy2y
 eyUTL+VBJHZJxYL7rBZWUzzmWGvJ5w57GMOdKHFN4E41dcYdd9gnsm+9sXmIGe+mImT/eAp
 7lu7/0xVVBFiunuDd6vng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

The fanotify interface is the basis for on access malware detection
in the Linux kernel. The development of a prior solution (DazukoFS)
has been stopped therefore.

Both free (ClamAV) as well as commercial viurs scanners (Sophos
Anti-Virus, AVG) using this interface exist.

Since kernel version 3.8.0 the implementationof the fanotify inter-
face is errorfree enough to be used on a productive system.
Personally I have been using it for virus scanning on multiple
systems for several months without issues while a developing a
wrapper around ClamAV, see
https://github.com/xypron/skyldav

A large scale usage of the fanotify interface can only expected if
the API is enabled by default.

Hence I recommend to change the Kconfig file accordingly.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/notify/fanotify/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/Kconfig b/fs/notify/fanotify/Kconfig
index e5f911b..929ad74 100644
--- a/fs/notify/fanotify/Kconfig
+++ b/fs/notify/fanotify/Kconfig
@@ -2,7 +2,7 @@ config FANOTIFY
 	bool "Filesystem wide access notification"
 	select FSNOTIFY
 	select ANON_INODES
-	default n
+	default y
 	---help---
 	   Say Y here to enable fanotify support.  fanotify is a file access
 	   notification system which differs from inotify in that it sends
@@ -15,7 +15,7 @@ config FANOTIFY_ACCESS_PERMISSIONS
 	bool "fanotify permissions checking"
 	depends on FANOTIFY
 	depends on SECURITY
-	default n
+	default y
 	---help---
 	   Say Y here is you want fanotify listeners to be able to make permissions
 	   decisions concerning filesystem events.  This is used by some fanotify
@@ -23,4 +23,4 @@ config FANOTIFY_ACCESS_PERMISSIONS
 	   use those files.  This is used by some anti-malware vendors and by some
 	   hierarchical storage managent systems.
 
-	   If unsure, say N.
+	   If unsure, say Y.
-- 
1.7.10.4

