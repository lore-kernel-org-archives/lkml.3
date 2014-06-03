Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaFCG26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:28:58 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48211 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaFCG25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:28:57 -0400
Date: Tue, 3 Jun 2014 15:28:08 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: dgap: rename dgap_finalize_board_init() to
 dgap_request_irq()
Message-ID: <20140603062808.GA7168@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 7a07a9b..b331108 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -188,7 +188,7 @@ static void dgap_do_fep_load(struct board_t *brd, const u8 *ufep, int len);
 static void dgap_do_conc_load(struct board_t *brd, u8 *uaddr, int len);
 #endif
 static int dgap_after_config_loaded(struct board_t *brd);
-static int dgap_finalize_board_init(struct board_t *brd);
+static int dgap_request_irq(struct board_t *brd);
 
 static void dgap_get_vpd(struct board_t *brd);
 static void dgap_do_reset_board(struct board_t *brd);
@@ -789,7 +789,7 @@ free_brd:
 }
 
 
-static int dgap_finalize_board_init(struct board_t *brd)
+static int dgap_request_irq(struct board_t *brd)
 {
 	int rc;
 
@@ -887,7 +887,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 	if (ret)
 		return ret;
 
-	ret = dgap_finalize_board_init(brd);
+	ret = dgap_request_irq(brd);
 	if (ret)
 		return ret;
 
-- 
1.7.1

