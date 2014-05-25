Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaEYSHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:07:13 -0400
Received: from mout.gmx.net ([212.227.17.20]:64205 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaEYSHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:07:11 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: lidza.louina@gmail.com
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] dgnc: Use time_after_eq()
Date: Sun, 25 May 2014 20:07:02 +0200
Message-Id: <1401041222-18992-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:w84mul56GVw9R0euGwP0tuwoTZG23oJ8iU94f2S05CP5ztfs5Jt
 XllUhuzjOFFKZHI9mD61mWCB4wvPDsFFpnBP4wjXB0jGkRjtGUIWG3r74RQxFUXq89pTCcp
 tpiAJRBADeSGMfbTWbxvrtVnxkWFlQZ5FsUDNrqR4yQLad8cyTgRSgXyIrh1kSHEcCp/BLt
 9K6hyqVO+0SDZdA4xRgIw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_after_eq() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/staging/dgnc/dgnc_neo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index cf22c7b..a8ca22a 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -395,7 +395,8 @@ static inline void neo_clear_break(struct channel_t *ch, int force)
 
 	/* Turn break off, and unset some variables */
 	if (ch->ch_flags & CH_BREAK_SENDING) {
-		if ((jiffies >= ch->ch_stop_sending_break) || force) {
+		if (time_after_eq(jiffies, ch->ch_stop_sending_break)
+		    || force) {
 			uchar temp = readb(&ch->ch_neo_uart->lcr);
 			writeb((temp & ~UART_LCR_SBC), &ch->ch_neo_uart->lcr);
 			neo_pci_posting_flush(ch->ch_bd);
-- 
1.7.10.4

