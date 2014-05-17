Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaEQXyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 19:54:37 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60197 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaEQXyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 19:54:36 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] staging: dgnc: dgnc_neo: Clean up if statement
Date: Sun, 18 May 2014 00:54:30 +0100
Message-Id: <1400370871-26361-3-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400370871-26361-1-git-send-email-massa.nomura@gmail.com>
References: <1400370871-26361-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix line over 80 characters and indenting of condition part.
Also, remove unnecessary braces to meet coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/staging/dgnc/dgnc_neo.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index e87cf49..10b6016 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -838,14 +838,14 @@ static void neo_param(struct tty_struct *tty)
 	 * Have the UART interrupt on modem signal changes ONLY when
 	 * we are in hardware flow control mode, or CLOCAL/FORCEDCD is not set.
 	 */
-	if ((ch->ch_digi.digi_flags & CTSPACE) || (ch->ch_digi.digi_flags & RTSPACE) ||
-		(ch->ch_c_cflag & CRTSCTS) || !(ch->ch_digi.digi_flags & DIGI_FORCEDCD) ||
-		!(ch->ch_c_cflag & CLOCAL))
-	{
+	if ((ch->ch_digi.digi_flags & CTSPACE) ||
+	    (ch->ch_digi.digi_flags & RTSPACE) ||
+	    (ch->ch_c_cflag & CRTSCTS) ||
+	    !(ch->ch_digi.digi_flags & DIGI_FORCEDCD) ||
+	    !(ch->ch_c_cflag & CLOCAL))
 		ier |= UART_IER_MSI;
-	} else {
+	else
 		ier &= ~UART_IER_MSI;
-	}
 
 	ier |= UART_IER_THRI;
 
-- 
1.7.9.5

