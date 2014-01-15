Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaAOWkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:40:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40717 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaAOVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Leitner <colin.leitner@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 019/166] USB: mos7840: correct handling of CS5 setting
Date: Wed, 15 Jan 2014 13:50:33 -0800
Message-Id: <1389822780-4729-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Leitner <colin.leitner@googlemail.com>

commit 78692cc3382e0603a47e1f2aaeffe0d99891994d upstream.

This patch removes an erroneous check of CSIZE, which made it impossible to set
CS5.

Compiles clean, but couldn't test against hardware.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7840.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 84502ea..716669e 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1926,25 +1926,25 @@ static void mos7840_change_port_settings(struct tty_struct *tty,
 	iflag = tty->termios.c_iflag;
 
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
-- 
1.8.3.2

