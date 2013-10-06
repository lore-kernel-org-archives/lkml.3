Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3JFXsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 19:48:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51711 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775Ab3JFXsy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 19:48:54 -0400
Message-ID: <1381103326.2788.45.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 1/2] sysrq: Document hexadecimal values for kernel.sysrq
 bitmask
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Bastian Blank <waldi@debian.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 07 Oct 2013 00:48:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes more sense to enter a bitmask in hexadecimal rather than
decimal.  Sadly we can't make it read back as hexadecimal.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/sysrq.txt | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index 8cb4d78..1c0471d 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -20,18 +20,21 @@ in /proc/sys/kernel/sysrq:
    1 - enable all functions of sysrq
   >1 - bitmask of allowed sysrq functions (see below for detailed function
        description):
-          2 - enable control of console logging level
-          4 - enable control of keyboard (SAK, unraw)
-          8 - enable debugging dumps of processes etc.
-         16 - enable sync command
-         32 - enable remount read-only
-         64 - enable signalling of processes (term, kill, oom-kill)
-        128 - allow reboot/poweroff
-        256 - allow nicing of all RT tasks
+          2 =   0x2 - enable control of console logging level
+          4 =   0x4 - enable control of keyboard (SAK, unraw)
+          8 =   0x8 - enable debugging dumps of processes etc.
+         16 =  0x10 - enable sync command
+         32 =  0x20 - enable remount read-only
+         64 =  0x40 - enable signalling of processes (term, kill, oom-kill)
+        128 =  0x80 - allow reboot/poweroff
+        256 = 0x100 - allow nicing of all RT tasks
 
 You can set the value in the file by the following command:
     echo "number" >/proc/sys/kernel/sysrq
 
+The number may be written either as decimal or as hexadecimal with the
+0x prefix.
+
 Note that the value of /proc/sys/kernel/sysrq influences only the invocation
 via a keyboard. Invocation of any operation via /proc/sysrq-trigger is always
 allowed (by a user with admin privileges).


-- 
Ben Hutchings
If at first you don't succeed, you're doing about average.
