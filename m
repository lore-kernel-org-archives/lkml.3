Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3LJIXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:23:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3LJIBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 41/52] Input: allow deselecting serio drivers even without CONFIG_EXPERT
Date: Tue, 10 Dec 2013 00:01:14 -0800
Message-Id: <20131210075957.081372079@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/keyboard/Kconfig |    4 ++--
 drivers/input/serio/Kconfig    |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

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
 		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !S390
@@ -169,7 +169,7 @@ config SERIO_MACEPS2
 	  module will be called maceps2.
 
 config SERIO_LIBPS2
-	tristate "PS/2 driver library" if EXPERT
+	tristate "PS/2 driver library"
 	depends on SERIO_I8042 || SERIO_I8042=n
 	help
 	  Say Y here if you are using a driver for device connected


