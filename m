Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaFCG2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:28:18 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40521 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbaFCG2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:28:17 -0400
Date: Tue, 3 Jun 2014 15:27:28 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: dgap: pass "brd" as a paramter to
 dgap_after_config_loaded()
Message-ID: <20140603062728.GA7161@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass "brd" to dgap_after_config_loaded() instead of passing
"dgap_numboards" and looking up brd again.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 9501a5e..7a07a9b 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -187,7 +187,7 @@ static void dgap_do_fep_load(struct board_t *brd, const u8 *ufep, int len);
 #ifdef DIGI_CONCENTRATORS_SUPPORTED
 static void dgap_do_conc_load(struct board_t *brd, u8 *uaddr, int len);
 #endif
-static int dgap_after_config_loaded(int board);
+static int dgap_after_config_loaded(struct board_t *brd);
 static int dgap_finalize_board_init(struct board_t *brd);
 
 static void dgap_get_vpd(struct board_t *brd);
@@ -859,7 +859,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 		kfree(dgap_config_buf);
 	}
 
-	ret = dgap_after_config_loaded(brd->boardnum);
+	ret = dgap_after_config_loaded(brd);
 	if (ret)
 		return ret;
 	/*
@@ -4113,8 +4113,10 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	}
 }
 
-static int dgap_after_config_loaded(int board)
+static int dgap_after_config_loaded(struct board_t *brd)
 {
+	int board = brd->boardnum;
+
 	/*
 	 * Initialize KME waitqueues...
 	 */
-- 
1.7.1

