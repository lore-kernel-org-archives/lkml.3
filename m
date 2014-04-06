Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaDFNhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:37:34 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:35880 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaDFNha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:37:30 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: edwin_rong <edwin_rong@realsil.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging: rts5139: Make variables inside #ifdef CONFIG_PM
Date: Sun,  6 Apr 2014 15:37:25 +0200
Message-Id: <1396791446-28626-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM=n:

drivers/staging/rts5139/rts51x_transport.c:649: warning: ‘media_not_present’ defined but not used
drivers/staging/rts5139/rts51x_transport.c:651: warning: ‘invalid_cmd_field’ defined but not used

Move the variables inside the #ifdef CONFIG_PM, and make them const while
we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/rts5139/rts51x_transport.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_transport.c b/drivers/staging/rts5139/rts51x_transport.c
index 74588d249b32..0db1345df94e 100644
--- a/drivers/staging/rts5139/rts51x_transport.c
+++ b/drivers/staging/rts5139/rts51x_transport.c
@@ -646,16 +646,18 @@ int rts51x_get_epc_status(struct rts51x_chip *chip, u16 *status)
 				    chip->usb->intr_urb->actual_length);
 }
 
-static u8 media_not_present[] = {
-	0x70, 0, 0x02, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0x3A, 0, 0, 0, 0, 0 };
-static u8 invalid_cmd_field[] = {
-	0x70, 0, 0x05, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0x24, 0, 0, 0, 0, 0 };
-
 void rts51x_invoke_transport(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	int result;
 
 #ifdef CONFIG_PM
+	static const u8 media_not_present[] = {
+		0x70, 0, 0x02, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0x3A, 0, 0, 0, 0, 0
+	};
+	static const u8 invalid_cmd_field[] = {
+		0x70, 0, 0x05, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0x24, 0, 0, 0, 0, 0
+	};
+
 	if (chip->option.ss_en) {
 		if (srb->cmnd[0] == TEST_UNIT_READY) {
 			if (RTS51X_CHK_STAT(chip, STAT_SS)) {
-- 
1.7.9.5

