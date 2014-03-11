Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaCKLIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:08:15 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:47862 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaCKLIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:08:13 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2] PM: Add missing "freeze" state
Date: Tue, 11 Mar 2014 12:08:11 +0100
Message-Id: <1394536091-28881-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - Update comments for state_show() as suggested by Srivatsa S. Bhat
    <srivatsa.bhat@linux.vnet.ibm.com>

 Documentation/ABI/testing/sysfs-power |    5 +++--
 kernel/power/main.c                   |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/testing/sysfs-power
index 205a73878441..64c9276e9421 100644
--- a/Documentation/ABI/testing/sysfs-power
+++ b/Documentation/ABI/testing/sysfs-power
@@ -12,8 +12,9 @@ Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/state file controls the system power state.
 		Reading from this file returns what states are supported,
-		which is hard-coded to 'standby' (Power-On Suspend), 'mem'
-		(Suspend-to-RAM), and 'disk' (Suspend-to-Disk).
+		which is hard-coded to 'freeze' (Low-Power Idle), 'standby'
+		(Power-On Suspend), 'mem' (Suspend-to-RAM), and 'disk'
+		(Suspend-to-Disk).
 
 		Writing to this file one of these strings causes the system to
 		transition into that state. Please see the file
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 1d1bf630e6e9..6271bc4073ef 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -282,8 +282,8 @@ struct kobject *power_kobj;
  *	state - control system power state.
  *
  *	show() returns what states are supported, which is hard-coded to
- *	'standby' (Power-On Suspend), 'mem' (Suspend-to-RAM), and
- *	'disk' (Suspend-to-Disk).
+ *	'freeze' (Low-Power Idle), 'standby' (Power-On Suspend),
+ *	'mem' (Suspend-to-RAM), and 'disk' (Suspend-to-Disk).
  *
  *	store() accepts one of those strings, translates it into the
  *	proper enumerated value, and initiates a suspend transition.
-- 
1.7.9.5

