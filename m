Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaC1KPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:15:24 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:57944 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaC1KPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:15:22 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] PM / Wakeup: Correct presence vs. emptiness of wakeup_* attributes
Date: Fri, 28 Mar 2014 11:15:14 +0100
Message-Id: <1396001714-17824-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

According to the documentation, the various wakeup_* attributes in sysfs
are not present if the device is not enabled to wake up the system.

This is not correct: the attributes are not present if the device is not
capable to wake up the system. They are empty if the device is not enabled
to wake up the system.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/ABI/testing/sysfs-devices-power |   46 ++++++++++++++++---------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-power b/Documentation/ABI/testing/sysfs-devices-power
index efe449bdf811..39b7b39b352e 100644
--- a/Documentation/ABI/testing/sysfs-devices-power
+++ b/Documentation/ABI/testing/sysfs-devices-power
@@ -83,8 +83,10 @@ Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_count attribute contains the number
 		of signaled wakeup events associated with the device.  This
-		attribute is read-only.  If the device is not enabled to wake up
+		attribute is read-only.  If the device is not capable to wake up
 		the system from sleep states, this attribute is not present.
+		If the device is not enabled to wake up the system from sleep
+		states, this attribute is empty.
 
 What:		/sys/devices/.../power/wakeup_active_count
 Date:		September 2010
@@ -93,8 +95,10 @@ Description:
 		The /sys/devices/.../wakeup_active_count attribute contains the
 		number of times the processing of wakeup events associated with
 		the device was completed (at the kernel level).  This attribute
-		is read-only.  If the device is not enabled to wake up the
-		system from sleep states, this attribute is not present.
+		is read-only.  If the device is not capable to wake up the
+		system from sleep states, this attribute is not present.  If
+		the device is not enabled to wake up the system from sleep
+		states, this attribute is empty.
 
 What:		/sys/devices/.../power/wakeup_abort_count
 Date:		February 2012
@@ -104,8 +108,9 @@ Description:
 		number of times the processing of a wakeup event associated with
 		the device might have aborted system transition into a sleep
 		state in progress.  This attribute is read-only.  If the device
-		is not enabled to wake up the system from sleep states, this
-		attribute is not present.
+		is not capable to wake up the system from sleep states, this
+		attribute is not present.  If the device is not enabled to wake
+		up the system from sleep states, this attribute is empty.
 
 What:		/sys/devices/.../power/wakeup_expire_count
 Date:		February 2012
@@ -114,8 +119,10 @@ Description:
 		The /sys/devices/.../wakeup_expire_count attribute contains the
 		number of times a wakeup event associated with the device has
 		been reported with a timeout that expired.  This attribute is
-		read-only.  If the device is not enabled to wake up the system
-		from sleep states, this attribute is not present.
+		read-only.  If the device is not capable to wake up the system
+		from sleep states, this attribute is not present.  If the
+		device is not enabled to wake up the system from sleep states,
+		this attribute is empty.
 
 What:		/sys/devices/.../power/wakeup_active
 Date:		September 2010
@@ -124,8 +131,10 @@ Description:
 		The /sys/devices/.../wakeup_active attribute contains either 1,
 		or 0, depending on whether or not a wakeup event associated with
 		the device is being processed (1).  This attribute is read-only.
-		If the device is not enabled to wake up the system from sleep
-		states, this attribute is not present.
+		If the device is not capable to wake up the system from sleep
+		states, this attribute is not present.  If the device is not
+		enabled to wake up the system from sleep states, this attribute
+		is empty.
 
 What:		/sys/devices/.../power/wakeup_total_time_ms
 Date:		September 2010
@@ -134,8 +143,9 @@ Description:
 		The /sys/devices/.../wakeup_total_time_ms attribute contains
 		the total time of processing wakeup events associated with the
 		device, in milliseconds.  This attribute is read-only.  If the
-		device is not enabled to wake up the system from sleep states,
-		this attribute is not present.
+		device is not capable to wake up the system from sleep states,
+		this attribute is not present.  If the device is not enabled to
+		wake up the system from sleep states, this attribute is empty.
 
 What:		/sys/devices/.../power/wakeup_max_time_ms
 Date:		September 2010
@@ -144,8 +154,10 @@ Description:
 		The /sys/devices/.../wakeup_max_time_ms attribute contains
 		the maximum time of processing a single wakeup event associated
 		with the device, in milliseconds.  This attribute is read-only.
-		If the device is not enabled to wake up the system from sleep
-		states, this attribute is not present.
+		If the device is not capable to wake up the system from sleep
+		states, this attribute is not present.  If the device is not
+		enabled to wake up the system from sleep states, this attribute
+		is empty.
 
 What:		/sys/devices/.../power/wakeup_last_time_ms
 Date:		September 2010
@@ -156,7 +168,8 @@ Description:
 		signaling the last wakeup event associated with the device, in
 		milliseconds.  This attribute is read-only.  If the device is
 		not enabled to wake up the system from sleep states, this
-		attribute is not present.
+		attribute is not present.  If the device is not enabled to wake
+		up the system from sleep states, this attribute is empty.
 
 What:		/sys/devices/.../power/wakeup_prevent_sleep_time_ms
 Date:		February 2012
@@ -165,9 +178,10 @@ Description:
 		The /sys/devices/.../wakeup_prevent_sleep_time_ms attribute
 		contains the total time the device has been preventing
 		opportunistic transitions to sleep states from occurring.
-		This attribute is read-only.  If the device is not enabled to
+		This attribute is read-only.  If the device is not capable to
 		wake up the system from sleep states, this attribute is not
-		present.
+		present.  If the device is not enabled to wake up the system
+		from sleep states, this attribute is empty.
 
 What:		/sys/devices/.../power/autosuspend_delay_ms
 Date:		September 2010
-- 
1.7.9.5

