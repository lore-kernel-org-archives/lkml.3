Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab3LSMdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:33:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3LSL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Gundersen <teg@jklm.no>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 104/208] Input: allow deselecting serio drivers even without CONFIG_EXPERT
Date: Thu, 19 Dec 2013 11:53:22 +0000
Message-Id: <1387454106-19326-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Gundersen <teg@jklm.no>

commit bcd2623073e98f69f84720308db0b142c4da0bd6 upstream.

There is plenty of consumer hardware (e.g., mac books) that does not use AT
keyboards or PS/2 mice. It therefore makes sense for distro kernels to
build the related drivers as modules to avoid loading them on hardware that
does not need them. As such, these options should no longer be protected by
EXPERT.

Moreover, building these drivers as modules gets rid of the following ugly
error during boot:

[    2.337745] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.439537] i8042: No controller found

Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/keyboard/Kconfig | 4 ++--
 drivers/input/serio/Kconfig    | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 269d4c3..2d31cec 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 menuconfig INPUT_KEYBOARD
-	bool "Keyboards" if EXPERT || !X86
+	bool "Keyboards"
 	default y
 	help
 	  Say Y here, and a list of supported keyboards will be displayed.
@@ -67,7 +67,7 @@ config KEYBOARD_ATARI
 	  module will be called atakbd.
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EXPERT || !X86
+	tristate "AT keyboard"
 	default y
 	select SERIO
 	select SERIO_LIBPS2
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 1e691a3..39c869d 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 config SERIO
-	tristate "Serial I/O support" if EXPERT || !X86
+	tristate "Serial I/O support"
 	default y
 	help
 	  Say Yes here if you have any input device that uses serial I/O to
@@ -19,7 +19,7 @@ config SERIO
 if SERIO
 
 config SERIO_I8042
-	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
+	tristate "i8042 PC Keyboard controller"
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
 		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !S390 && \
@@ -170,7 +170,7 @@ config SERIO_MACEPS2
 	  module will be called maceps2.
 
 config SERIO_LIBPS2
-	tristate "PS/2 driver library" if EXPERT
+	tristate "PS/2 driver library"
 	depends on SERIO_I8042 || SERIO_I8042=n
 	help
 	  Say Y here if you are using a driver for device connected
-- 
1.8.3.2

