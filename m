Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3L2CKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55247 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393Ab3L2CKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:20 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Colin Leitner" <colin.leitner@googlemail.com>,
        "Colin Leitner" <colin.leitner@gmail.com>,
        "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.468896709@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 117/185] USB: spcp8x5: correct handling of CS5 setting
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Leitner <colin.leitner@googlemail.com>

commit 711fbdfbf2bc4827214a650afe3f64767a1aba16 upstream.

This patch removes an erroneous check of CSIZE, which made it impossible to set
CS5.

Compiles clean, but couldn't test against hardware.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/spcp8x5.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -394,22 +394,20 @@ static void spcp8x5_set_termios(struct t
 	}
 
 	/* Set Data Length : 00:5bit, 01:6bit, 10:7bit, 11:8bit */
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS5:
-			buf[1] |= SET_UART_FORMAT_SIZE_5;
-			break;
-		case CS6:
-			buf[1] |= SET_UART_FORMAT_SIZE_6;
-			break;
-		case CS7:
-			buf[1] |= SET_UART_FORMAT_SIZE_7;
-			break;
-		default:
-		case CS8:
-			buf[1] |= SET_UART_FORMAT_SIZE_8;
-			break;
-		}
+	switch (cflag & CSIZE) {
+	case CS5:
+		buf[1] |= SET_UART_FORMAT_SIZE_5;
+		break;
+	case CS6:
+		buf[1] |= SET_UART_FORMAT_SIZE_6;
+		break;
+	case CS7:
+		buf[1] |= SET_UART_FORMAT_SIZE_7;
+		break;
+	default:
+	case CS8:
+		buf[1] |= SET_UART_FORMAT_SIZE_8;
+		break;
 	}
 
 	/* Set Stop bit2 : 0:1bit 1:2bit */

