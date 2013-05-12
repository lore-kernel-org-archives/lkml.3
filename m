Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3ELOpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:45:07 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36551 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3ELOpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:45:03 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, usb-storage@lists.one-eyed-alien.net,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH 2/2] usb: storage: alauda: initialize variables directly
Date: Sun, 12 May 2013 11:43:23 -0300
Message-Id: <1368369803-17656-2-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1368369803-17656-1-git-send-email-emilio@elopez.com.ar>
References: <1368369803-17656-1-git-send-email-emilio@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the code a bit to initialize the variables directly when
defining them.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---

Please note that this patch is untested.

 drivers/usb/storage/alauda.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 77a2ddf..6636a58 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -249,11 +249,7 @@ static void nand_init_ecc(void) {
 /* compute 3-byte ecc on 256 bytes */
 static void nand_compute_ecc(unsigned char *data, unsigned char *ecc) {
 	int i, j, a;
-	unsigned char par, bit, bits[8];
-
-	par = 0;
-	for (j = 0; j < 8; j++)
-		bits[j] = 0;
+	unsigned char par = 0, bit, bits[8] = {0};
 
 	/* collect 16 checksum bits */
 	for (i = 0; i < 256; i++) {
-- 
1.8.2.3

