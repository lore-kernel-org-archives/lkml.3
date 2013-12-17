Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3LQSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:25:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32837 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3LQSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Leitner <colin.leitner@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 073/103] USB: spcp8x5: correct handling of CS5 setting
Date: Tue, 17 Dec 2013 18:13:02 +0000
Message-Id: <1387304012-23805-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Leitner <colin.leitner@googlemail.com>

commit 711fbdfbf2bc4827214a650afe3f64767a1aba16 upstream.

This patch removes an erroneous check of CSIZE, which made it impossible to set
CS5.

Compiles clean, but couldn't test against hardware.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/spcp8x5.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 10760f2..02fde0b 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -385,22 +385,20 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
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
-- 
1.8.3.2

