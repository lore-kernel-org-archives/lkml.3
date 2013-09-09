Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3IIOUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:20:15 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:55234 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237Ab3IIOUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:20:11 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 10:20:11 EDT
X-RRZE-Submit-IP: 10.21.5.52
From: Tobias Polzer <tobias.polzer@fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, usbip-devel@lists.sourceforge.net,
        Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, Tobias Polzer <tobias.polzer@fau.de>,
        Dominik Paulus <dominik.paulus@fau.de>
Subject: [PATCH] Fix man-pages for usbip userspace utilities
Date: Mon,  9 Sep 2013 16:13:15 +0200
Message-Id: <1378736003-19715-1-git-send-email-tobias.polzer@fau.de>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usbip userspace utilities contained some half-documented (only in
--help, not in man) options. They were added to the man-pages of usbip
and usbipd.
Also a typo in the usbip headline was fixed.

Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
---
 drivers/staging/usbip/userspace/doc/usbip.8  |  8 +++++++-
 drivers/staging/usbip/userspace/doc/usbipd.8 | 27 ++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/userspace/doc/usbip.8 b/drivers/staging/usbip/userspace/doc/usbip.8
index ccdadc8..a6097be 100644
--- a/drivers/staging/usbip/userspace/doc/usbip.8
+++ b/drivers/staging/usbip/userspace/doc/usbip.8
@@ -3,7 +3,7 @@
 usbip \- manage USB/IP devices
 .SH SYNOPSIS
 .B usbip
-[\foptions\R] <\fIcommand\fR> <\fIargs\fR>
+[\fIoptions\fR] <\fIcommand\fR> <\fIargs\fR>
 
 .SH DESCRIPTION
 On a USB/IP server, devices can be listed, bound, and unbound using
@@ -23,6 +23,12 @@ Print debugging information.
 Log to syslog.
 .PP
 
+.HP
+\fB\-\-tcp-port PORT\fR
+.IP
+Connect to PORT on remote host (used for attach and list --remote).
+.PP
+
 .SH COMMANDS
 .HP
 \fBversion\fR
diff --git a/drivers/staging/usbip/userspace/doc/usbipd.8 b/drivers/staging/usbip/userspace/doc/usbipd.8
index d896936..ac4635d 100644
--- a/drivers/staging/usbip/userspace/doc/usbipd.8
+++ b/drivers/staging/usbip/userspace/doc/usbipd.8
@@ -14,10 +14,22 @@ Devices have to explicitly be exported using
 before usbipd makes them available to other hosts.
 
 The daemon accepts connections from USB/IP clients
-on TCP port 3240.
+on TCP port 3240 by default.
 
 .SH OPTIONS
 .HP
+\fB\-4\fR, \fB\-\-ipv4\fR
+.IP
+Bind to IPv4. Default is both.
+.PP
+
+.HP
+\fB\-6\fR, \fB\-\-ipv6\fR
+.IP
+Bind to IPv6. Default is both.
+.PP
+
+.HP
 \fB\-D\fR, \fB\-\-daemon\fR
 .IP
 Run as a daemon process.
@@ -29,6 +41,19 @@ Run as a daemon process.
 Print debugging information.
 .PP
 
+.HP
+\fB\-PFILE\fR, \fB\-\-pid FILE\fR
+.IP
+Write process id to FILE.
+.br
+If no FILE specified, use /var/run/usbipd.pid
+.PP
+
+\fB\-tPORT\fR, \fB\-\-tcp\-port PORT\fR
+.IP
+Listen on TCP/IP port PORT.
+.PP
+
 \fB\-h\fR, \fB\-\-help\fR
 .IP
 Print the program help message and exit.
-- 
1.8.4.rc3

