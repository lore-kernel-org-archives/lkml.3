Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3L2Cia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:38:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55429 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848Ab3L2CKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:39 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Colin Leitner" <colin.leitner@gmail.com>,
        "Colin Leitner" <colin.leitner@googlemail.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.369558416@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 118/185] USB: mos7840: correct handling of CS5 setting
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

commit 78692cc3382e0603a47e1f2aaeffe0d99891994d upstream.

This patch removes an erroneous check of CSIZE, which made it impossible to set
CS5.

Compiles clean, but couldn't test against hardware.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mos7840.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1987,25 +1987,25 @@ static void mos7840_change_port_settings
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

