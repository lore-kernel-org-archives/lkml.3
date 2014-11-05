Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbaKER2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:28:31 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52433 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755576AbaKER04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:26:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 5/9] serial: hp300: Remove obsolete comments
Date: Wed,  5 Nov 2014 12:26:28 -0500
Message-Id: <1415208392-16189-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_serial_console() is obsolete and has been superseded by
early_serial_setup() which is called at the end of the function.

The IA64 arch does not call this function; only the m68k arch setup
calls this function.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_hp300.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_hp300.c b/drivers/tty/serial/8250/8250_hp300.c
index afffe4d..b488208 100644
--- a/drivers/tty/serial/8250/8250_hp300.c
+++ b/drivers/tty/serial/8250/8250_hp300.c
@@ -88,10 +88,6 @@ extern int hp300_uart_scode;
 /*
  * Parse the bootinfo to find descriptions for headless console and
  * debug serial ports and register them with the 8250 driver.
- * This function should be called before serial_console_init() is called
- * to make sure the serial console will be available for use. IA-64 kernel
- * calls this function from setup_arch() after the EFI and ACPI tables have
- * been parsed.
  */
 int __init hp300_setup_serial_console(void)
 {
-- 
2.1.3

