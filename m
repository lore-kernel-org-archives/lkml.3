Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaFMJXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:23:02 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53399 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaFMJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:23:00 -0400
Date: Fri, 13 Jun 2014 18:22:05 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7 RESEND] staging: dgap: rename dgap_after_config_loaded()
 to dgap_alloc_flipbuf()
Message-ID: <20140613092205.GA3792@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_after_config_loaded() as function name doesn't tell
what it does.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
resend: reordering this series of patches, becasue some patches
are merged into one.

 drivers/staging/dgap/dgap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 497e6f3..721404f 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -188,7 +188,7 @@ static void dgap_do_fep_load(struct board_t *brd, const u8 *ufep, int len);
 #ifdef DIGI_CONCENTRATORS_SUPPORTED
 static void dgap_do_conc_load(struct board_t *brd, u8 *uaddr, int len);
 #endif
-static int dgap_after_config_loaded(struct board_t *brd);
+static int dgap_alloc_flipbuf(struct board_t *brd);
 static int dgap_request_irq(struct board_t *brd);
 static void dgap_free_irq(struct board_t *brd);
 
@@ -865,7 +865,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 		kfree(dgap_config_buf);
 	}
 
-	ret = dgap_after_config_loaded(brd);
+	ret = dgap_alloc_flipbuf(brd);
 	if (ret)
 		return ret;
 	/*
@@ -4133,7 +4133,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	}
 }
 
-static int dgap_after_config_loaded(struct board_t *brd)
+static int dgap_alloc_flipbuf(struct board_t *brd)
 {
 	/*
 	 * Initialize KME waitqueues...
-- 
1.7.1

