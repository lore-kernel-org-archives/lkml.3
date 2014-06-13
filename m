Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaFMJWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:22:00 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46184 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaFMJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:21:59 -0400
Date: Fri, 13 Jun 2014 18:21:04 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7 RESEND] staging: dgap: introduce dgap_free_irq()
Message-ID: <20140613092104.GA3785@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_free_irq() will free the irq which is requested in
dgap_request_irq().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
resend: reordering this series of patches, because some patches are
merged to one.

 drivers/staging/dgap/dgap.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index eab8fd5..497e6f3 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -190,6 +190,7 @@ static void dgap_do_conc_load(struct board_t *brd, u8 *uaddr, int len);
 #endif
 static int dgap_after_config_loaded(struct board_t *brd);
 static int dgap_request_irq(struct board_t *brd);
+static void dgap_free_irq(struct board_t *brd);
 
 static void dgap_get_vpd(struct board_t *brd);
 static void dgap_do_reset_board(struct board_t *brd);
@@ -634,8 +635,7 @@ static void dgap_cleanup_board(struct board_t *brd)
 	if (!brd || brd->magic != DGAP_BOARD_MAGIC)
 		return;
 
-	if (brd->intr_used && brd->irq)
-		free_irq(brd->irq, brd);
+	dgap_free_irq(brd);
 
 	tasklet_kill(&brd->helper_tasklet);
 
@@ -816,6 +816,12 @@ static int dgap_request_irq(struct board_t *brd)
 	return 0;
 }
 
+static void dgap_free_irq(struct board_t *brd)
+{
+	if (brd->intr_used && brd->irq)
+		free_irq(brd->irq, brd);
+}
+
 static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 {
 	struct board_t *brd = dgap_board[dgap_numboards - 1];
-- 
1.7.1

