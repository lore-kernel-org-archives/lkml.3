Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3LJIjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:39:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3LJH70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Colin Leitner <colin.leitner@gmail.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 22/25] USB: mos7840: correct handling of CS5 setting
Date: Tue, 10 Dec 2013 00:00:30 -0800
Message-Id: <20131210075932.371320145@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
References: <20131210075930.808460227@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Leitner <colin.leitner@googlemail.com>

commit 78692cc3382e0603a47e1f2aaeffe0d99891994d upstream.

This patch removes an erroneous check of CSIZE, which made it impossible to set
CS5.

Compiles clean, but couldn't test against hardware.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1962,25 +1962,25 @@ static void mos7840_change_port_settings
 	iflag = tty->termios->c_iflag;
 
 	/* Change the number of bits */
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS5:
-			lData = LCR_BITS_5;
-			break;
+	switch (cflag & CSIZE) {
+	case CS5:
+		lData = LCR_BITS_5;
+		break;
 
-		case CS6:
-			lData = LCR_BITS_6;
-			break;
+	case CS6:
+		lData = LCR_BITS_6;
+		break;
 
-		case CS7:
-			lData = LCR_BITS_7;
-			break;
-		default:
-		case CS8:
-			lData = LCR_BITS_8;
-			break;
-		}
+	case CS7:
+		lData = LCR_BITS_7;
+		break;
+
+	default:
+	case CS8:
+		lData = LCR_BITS_8;
+		break;
 	}
+
 	/* Change the Parity bit */
 	if (cflag & PARENB) {
 		if (cflag & PARODD) {


