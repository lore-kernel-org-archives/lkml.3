Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788Ab3BMRWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:22:38 -0500
Received: from barbershop.grep.be ([89.106.240.122]:40398 "EHLO
	barbershop.grep.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934457Ab3BMRWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:22:35 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 12:22:35 EST
From: Wouter Verhelst <w@uter.be>
To: linux-kernel@vger.kernel.org
Cc: Wouter Verhelst <w@uter.be>, <nbd-general@lists.sf.net>,
        Paul Clements <Paul.Clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Update documentation for nbd, and link to mailinglist
Date: Wed, 13 Feb 2013 18:21:50 +0100
Message-Id: <1360776110-6022-1-git-send-email-w@uter.be>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/blockdev/nbd.txt contained some documentation which was
horribly outdated and probably still dates from the original patch that
added NBD support to the kernel.

This patch removes the useless and outdated bits. The tools on
nbd.sf.net are fully documented in manpages, which is where
documentation for the non-kernel bits should live.

Additionally, add a reference to the MAINTAINERS file for the
nbd-general mailinglist that is used for discussion of the userland
tools and the kernel module already.

Cc: <nbd-general@lists.sf.net>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Wouter Verhelst <w@uter.be>
---
 Documentation/blockdev/nbd.txt |   38 ++++----------------------------------
 MAINTAINERS                    |    1 +
 2 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/Documentation/blockdev/nbd.txt b/Documentation/blockdev/nbd.txt
index aeb93ff..271e607 100644
--- a/Documentation/blockdev/nbd.txt
+++ b/Documentation/blockdev/nbd.txt
@@ -4,43 +4,13 @@
    can use a remote server as one of its block devices. So every time
    the client computer wants to read, e.g., /dev/nb0, it sends a
    request over TCP to the server, which will reply with the data read.
-   This can be used for stations with low disk space (or even diskless -
-   if you boot from floppy) to borrow disk space from another computer.
-   Unlike NFS, it is possible to put any filesystem on it, etc. It should
-   even be possible to use NBD as a root filesystem (I've never tried),
-   but it requires a user-level program to be in the initrd to start.
-   It also allows you to run block-device in user land (making server
-   and client physically the same computer, communicating using loopback).
-   
-   Current state: It currently works. Network block device is stable.
-   I originally thought that it was impossible to swap over TCP. It
-   turned out not to be true - swapping over TCP now works and seems
-   to be deadlock-free, but it requires heavy patches into Linux's
-   network layer.
-   
+   This can be used for stations with low disk space (or even diskless)
+   to borrow disk space from another computer.
+   Unlike NFS, it is possible to put any filesystem on it, etc.
+
    For more information, or to download the nbd-client and nbd-server
    tools, go to http://nbd.sf.net/.
 
-   Howto: To setup nbd, you can simply do the following:
-
-   First, serve a device or file from a remote server:
-
-   nbd-server <port-number> <device-or-file-to-serve-to-client>
-
-   e.g.,
-	root@server1 # nbd-server 1234 /dev/sdb1
-
-	(serves sdb1 partition on TCP port 1234)
-
-   Then, on the local (client) system:
-
-   nbd-client <server-name-or-IP> <server-port-number> /dev/nb[0-n]
-
-   e.g.,
-	root@client1 # nbd-client server1 1234 /dev/nb0
-
-	(creates the nb0 device on client1)
-
    The nbd kernel module need only be installed on the client
    system, as the nbd-server is completely in userspace. In fact,
    the nbd-server has been successfully ported to other operating
diff --git a/MAINTAINERS b/MAINTAINERS
index 35a56bc..028d719 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5236,6 +5236,7 @@ F:	net/netrom/
 NETWORK BLOCK DEVICE (NBD)
 M:	Paul Clements <Paul.Clements@steeleye.com>
 S:	Maintained
+L:	nbd-general@lists.sourceforge.net
 F:	Documentation/blockdev/nbd.txt
 F:	drivers/block/nbd.c
 F:	include/linux/nbd.h
-- 
1.7.10.4

