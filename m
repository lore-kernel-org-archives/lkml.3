Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbbABLHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 06:07:48 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:43629 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbbABLHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 06:07:46 -0500
X-Greylist: delayed 172003 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2015 06:07:45 EST
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: dvhart@linux.intel.com, pali.rohar@gmail.com, computersforpeace@gmail.com,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        A.Sloman@cs.bham.ac.uk, Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH] Documentation: dell-laptop: correct als_setting description
Date: Fri,  2 Jan 2015 12:06:50 +0100
Message-Id: <1420196810-8855-1-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was incorrectly stated that als_setting is to enable and disable
the ambient light sensor on supported system rather than setting a
threshold value. Correct the description and add a note to make more
clear what could be the effect of changing als_setting.

Reported-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 Documentation/ABI/testing/sysfs-platform-dell-laptop | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop b/Documentation/ABI/testing/sysfs-platform-dell-laptop
index 7969443..a40c217 100644
--- a/Documentation/ABI/testing/sysfs-platform-dell-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
@@ -4,10 +4,12 @@ KernelVersion:	3.19
 Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
 		Pali Rohár <pali.rohar@gmail.com>
 Description:
-		This file allows to control the automatic keyboard
-		illumination mode on some systems that have an ambient
-		light sensor. Write 1 to this file to enable the auto
-		mode, 0 to disable it.
+		This file allows to set at which value reported by the
+		ambient light sensor the keyboard backlight has to be
+		turned on or off.
+
+		Note that the 'als' trigger must be supported and enabled
+		for this setting to have any effect.
 
 What:		/sys/class/leds/dell::kbd_backlight/start_triggers
 Date:		December 2014
@@ -32,6 +34,13 @@ Description:
 
 		Note that not all the available triggers can be configured.
 
+		Note also that enabling the 'als' trigger could simply
+		alter the behavior of the other triggers and not allow
+		the ambient light sensor control the keyboard illumination
+		independently. It could prevent other triggers from turning
+		the keyboard backlight on or force them to turn it off
+		depending on the current ambient light and als_setting.
+
 What:		/sys/class/leds/dell::kbd_backlight/stop_timeout
 Date:		December 2014
 KernelVersion:	3.19
-- 
2.1.4

