Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3KVSGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:06:45 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41198 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab3KVSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:06:39 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH staging-next 4/4] staging/fwserial: Add Kconfig options for max ports
Date: Fri, 22 Nov 2013 13:06:11 -0500
Message-Id: <1385143571-3571-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
References: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow kernel configuration of max supported ports for
TTY-over-Firewire driver.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/Kconfig    | 20 ++++++++++++++++++++
 drivers/staging/fwserial/fwserial.h |  4 ++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fwserial/Kconfig b/drivers/staging/fwserial/Kconfig
index a0812d9..9c7c926 100644
--- a/drivers/staging/fwserial/Kconfig
+++ b/drivers/staging/fwserial/Kconfig
@@ -9,3 +9,23 @@ config FIREWIRE_SERIAL
 
 	  To compile this driver as a module, say M here:  the module will
 	  be called firewire-serial.
+
+if FIREWIRE_SERIAL
+
+config FWTTY_MAX_TOTAL_PORTS
+       int "Maximum number of serial ports supported"
+       default "64"
+       help
+          Set this to the maximum number of serial ports you want the
+	  firewire-serial driver to support.
+
+config FWTTY_MAX_CARD_PORTS
+       int "Maximum number of serial ports supported per adapter"
+       range 0 FWTTY_MAX_TOTAL_PORTS
+       default "32"
+       help
+          Set this to the maximum number of serial ports each firewire
+	  adapter supports. The actual number of serial ports registered
+	  is set with the module parameter "ttys".
+
+endif
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index eab85b4..54f7f9b 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -291,8 +291,8 @@ struct fwtty_port {
 #define FREQ_BREAKS        (HZ / 50)
 
 /* Ports are allocated in blocks of num_ports for each fw_card */
-#define MAX_CARD_PORTS           32	/* max # of ports per card */
-#define MAX_TOTAL_PORTS          64	/* max # of ports total    */
+#define MAX_CARD_PORTS           CONFIG_FWTTY_MAX_CARD_PORTS
+#define MAX_TOTAL_PORTS          CONFIG_FWTTY_MAX_TOTAL_PORTS
 
 /* tuning parameters */
 #define FWTTY_PORT_TXFIFO_LEN	4096
-- 
1.8.1.2

