Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877AbaEQQeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:34:12 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35043 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030208AbaEQQdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:33:43 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH 3/4] staging: dgnc: dgnc_neo: Fix conditional part of if statement
Date: Sat, 17 May 2014 17:30:53 +0100
Message-Id: <1400344254-13007-4-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
References: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix line over 80 characters of if-condition part and also
indent the lines to tell the difference between the condition and
body of the if statement.

Then I think we can keep the readability and meet coding style
with this change.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/staging/dgnc/dgnc_neo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index 8988346..c211f9f 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -838,9 +838,11 @@ static void neo_param(struct tty_struct *tty)
 	 * Have the UART interrupt on modem signal changes ONLY when
 	 * we are in hardware flow control mode, or CLOCAL/FORCEDCD is not set.
 	 */
-	if ((ch->ch_digi.digi_flags & CTSPACE) || (ch->ch_digi.digi_flags & RTSPACE) ||
-		(ch->ch_c_cflag & CRTSCTS) || !(ch->ch_digi.digi_flags & DIGI_FORCEDCD) ||
-		!(ch->ch_c_cflag & CLOCAL)) {
+	if ((ch->ch_digi.digi_flags & CTSPACE)
+			|| (ch->ch_digi.digi_flags & RTSPACE)
+			|| (ch->ch_c_cflag & CRTSCTS)
+			|| !(ch->ch_digi.digi_flags & DIGI_FORCEDCD)
+			|| !(ch->ch_c_cflag & CLOCAL)) {
 		ier |= UART_IER_MSI;
 	} else {
 		ier &= ~UART_IER_MSI;
-- 
1.7.9.5

