Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068Ab3HHIAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:00:53 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54025 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934052Ab3HHIAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:00:49 -0400
From: Milo Kim <woogyom.kim@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Milo Kim <milo.kim@ti.com>
Subject: [PATCH 09/10] Documentation: leds-lp5521,lp5523: update device attribute information
Date: Thu,  8 Aug 2013 16:59:53 +0900
Message-Id: <1375948794-6286-10-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, all legacy application interfaces are restored.
Each driver documentation is updated.

Cc: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 Documentation/leds/leds-lp5521.txt |   20 +++++++++++++++++++-
 Documentation/leds/leds-lp5523.txt |   21 ++++++++++++++++++++-
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/Documentation/leds/leds-lp5521.txt b/Documentation/leds/leds-lp5521.txt
index 79e4c2e..d08d8c1 100644
--- a/Documentation/leds/leds-lp5521.txt
+++ b/Documentation/leds/leds-lp5521.txt
@@ -18,7 +18,25 @@ All three channels can be also controlled using the engine micro programs.
 More details of the instructions can be found from the public data sheet.
 
 LP5521 has the internal program memory for running various LED patterns.
-For the details, please refer to 'firmware' section in leds-lp55xx.txt
+There are two ways to run LED patterns.
+
+1) Legacy interface - enginex_mode and enginex_load
+  Control interface for the engines:
+  x is 1 .. 3
+  enginex_mode : disabled, load, run
+  enginex_load : store program (visible only in engine load mode)
+
+  Example (start to blink the channel 2 led):
+  cd   /sys/class/leds/lp5521:channel2/device
+  echo "load" > engine3_mode
+  echo "037f4d0003ff6000" > engine3_load
+  echo "run" > engine3_mode
+
+  To stop the engine:
+  echo "disabled" > engine3_mode
+
+2) Firmware interface - LP55xx common interface
+  For the details, please refer to 'firmware' section in leds-lp55xx.txt
 
 sysfs contains a selftest entry.
 The test communicates with the chip and checks that
diff --git a/Documentation/leds/leds-lp5523.txt b/Documentation/leds/leds-lp5523.txt
index 899fdad..5b3e91d 100644
--- a/Documentation/leds/leds-lp5523.txt
+++ b/Documentation/leds/leds-lp5523.txt
@@ -28,7 +28,26 @@ If both fields are NULL, 'lp5523' is used by default.
 /sys/class/leds/lp5523:channelN  (N: 0 ~ 8)
 
 LP5523 has the internal program memory for running various LED patterns.
-For the details, please refer to 'firmware' section in leds-lp55xx.txt
+There are two ways to run LED patterns.
+
+1) Legacy interface - enginex_mode, enginex_load and enginex_leds
+  Control interface for the engines:
+  x is 1 .. 3
+  enginex_mode : disabled, load, run
+  enginex_load : microcode load (visible only in load mode)
+  enginex_leds : led mux control (visible only in load mode)
+
+  cd /sys/class/leds/lp5523:channel2/device
+  echo "load" > engine3_mode
+  echo "9d80400004ff05ff437f0000" > engine3_load
+  echo "111111111" > engine3_leds
+  echo "run" > engine3_mode
+
+  To stop the engine:
+  echo "disabled" > engine3_mode
+
+2) Firmware interface - LP55xx common interface
+  For the details, please refer to 'firmware' section in leds-lp55xx.txt
 
 Selftest uses always the current from the platform data.
 
-- 
1.7.9.5

