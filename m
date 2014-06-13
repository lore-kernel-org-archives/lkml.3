Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaFMJUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:20:01 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39665 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaFMJT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:19:58 -0400
Date: Fri, 13 Jun 2014 18:19:03 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7 RESEND] staging: dgap: get rid of brd->firstminor because
 it is 0
Message-ID: <20140613091903.GA3768@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

firstminor in struct borad_t is always zero, so it
can be removed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
resend: reordering this series of patches

 drivers/staging/dgap/dgap.c |    9 ++++-----
 drivers/staging/dgap/dgap.h |    1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index c1f2798..352eb1b 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -684,7 +684,6 @@ static int dgap_found_board(struct pci_dev *pdev, int id, int boardnum)
 	/* store the info for the board we've found */
 	brd->magic = DGAP_BOARD_MAGIC;
 	brd->boardnum = boardnum;
-	brd->firstminor = 0;
 	brd->vendor = dgap_pci_tbl[id].vendor;
 	brd->device = dgap_pci_tbl[id].device;
 	brd->pdev = pdev;
@@ -4168,8 +4167,8 @@ static int dgap_tty_register_ports(struct board_t *brd)
 		struct device *classp;
 
 		classp = tty_port_register_device(&brd->serial_ports[i],
-					brd->serial_driver,
-					brd->firstminor + i, NULL);
+						  brd->serial_driver,
+						  i, NULL);
 
 		if (IS_ERR(classp)) {
 			ret = PTR_ERR(classp);
@@ -4180,8 +4179,8 @@ static int dgap_tty_register_ports(struct board_t *brd)
 		ch->ch_tun.un_sysfs = classp;
 
 		classp = tty_port_register_device(&brd->printer_ports[i],
-					brd->print_driver,
-					brd->firstminor + i, NULL);
+						  brd->print_driver,
+						  i, NULL);
 
 		if (IS_ERR(classp)) {
 			ret = PTR_ERR(classp);
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index 03c020e..c00b2e2 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -529,7 +529,6 @@ struct macounter {
 struct board_t {
 	int		magic;		/* Board Magic number.  */
 	int		boardnum;	/* Board number: 0-3 */
-	int		firstminor;	/* First minor, e.g. 0, 30, 60 */
 
 	int		type;		/* Type of board */
 	char		*name;		/* Product Name */
-- 
1.7.1

