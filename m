Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3LJIGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:06:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3LJICm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Colin Leitner <colin.leitner@gmail.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.12 60/62] USB: spcp8x5: correct handling of CS5 setting
Date: Tue, 10 Dec 2013 00:01:31 -0800
Message-Id: <20131210080101.605912350@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Leitner <colin.leitner@googlemail.com>

commit 711fbdfbf2bc4827214a650afe3f64767a1aba16 upstream.

This patch removes an erroneous check of CSIZE, which made it impossible to set
CS5.

Compiles clean, but couldn't test against hardware.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/spcp8x5.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -348,22 +348,20 @@ static void spcp8x5_set_termios(struct t
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


