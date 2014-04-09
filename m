Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066AbaDIQaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:30:10 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44428 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaDIQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:30:08 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:dgnc:dgnc_driver open/close braces
Date: Wed,  9 Apr 2014 17:30:04 +0100
Message-Id: <1397061004-7924-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: that open brace { should be on the previous line
ERROR: else should follow close brace '}
ERROR: space required before the open parenthesis '(
ERROR: trailing whitespace
ERROR: open brace '{' following function declarations go on the next line
ERROR: space required after that ',' (ctx:VxV)
ERROR: space required before the open parenthesis '('

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index b1a39b2..7c853c4 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -88,8 +88,7 @@ module_exit(dgnc_cleanup_module);
 /*
  * File operations permitted on Control/Management major.
  */
-static const struct file_operations dgnc_BoardFops =
-{
+static const struct file_operations dgnc_BoardFops = {
 	.owner		=	THIS_MODULE,
 	.unlocked_ioctl =  	dgnc_mgmt_ioctl,
 	.open		=	dgnc_mgmt_open,
@@ -153,8 +152,7 @@ struct board_id {
 	unsigned int is_pci_express;
 };
 
-static struct board_id dgnc_Ids[] =
-{
+static struct board_id dgnc_Ids[] = {
 	{	PCI_DEVICE_CLASSIC_4_PCI_NAME,		4,	0	},
 	{	PCI_DEVICE_CLASSIC_4_422_PCI_NAME,	4,	0	},
 	{	PCI_DEVICE_CLASSIC_8_PCI_NAME,		8,	0	},
@@ -239,8 +237,7 @@ int dgnc_init_module(void)
 			pr_warn("WARNING: dgnc driver load failed.  No Digi Neo or Classic boards found.\n");
 
 		dgnc_cleanup_module();
-	}
-	else {
+	} else {
 		dgnc_create_driver_sysfiles(&dgnc_driver);
 	}
 
@@ -410,7 +407,7 @@ static void dgnc_cleanup_board(struct dgnc_board *brd)
 {
 	int i = 0;
 
-	if(!brd || brd->magic != DGNC_BOARD_MAGIC)
+	if (!brd || brd->magic != DGNC_BOARD_MAGIC)
 		return;
 
 	switch (brd->device) {
@@ -488,7 +485,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 	/* get the board structure and prep it */
 	brd = dgnc_Board[dgnc_NumBoards] =
 		kzalloc(sizeof(*brd), GFP_KERNEL);
-	if (!brd) 
+	if (!brd)
 		return -ENOMEM;
 
 	/* make a temporary message buffer for the boot messages */
@@ -532,7 +529,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 	brd->irq = pci_irq;
 
 
-	switch(brd->device) {
+	switch (brd->device) {
 
 	case PCI_DEVICE_CLASSIC_4_DID:
 	case PCI_DEVICE_CLASSIC_8_DID:
@@ -719,7 +716,8 @@ failed:
 }
 
 
-static int dgnc_finalize_board_init(struct dgnc_board *brd) {
+static int dgnc_finalize_board_init(struct dgnc_board *brd)
+{
 	int rc = 0;
 
 	DPR_INIT(("dgnc_finalize_board_init() - start\n"));

@@ -895,7 +893,7 @@ int dgnc_ms_sleep(ulong ms)
  */
 char *dgnc_ioctl_name(int cmd)
 {
-	switch(cmd) {
+	switch (cmd) {
 
 	case TCGETA:		return "TCGETA";
 	case TCGETS:		return "TCGETS";
-- 
1.8.3.2

