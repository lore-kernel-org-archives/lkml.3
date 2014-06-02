Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaFBFJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:09:53 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46159 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaFBFJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:09:52 -0400
Date: Mon, 2 Jun 2014 14:09:04 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging: dgap: make dgap_config_buf a local buffer
Message-ID: <20140602050904.GA29921@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_config_buf is only used in dgap_firmware_load().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 3e716fe..c78c8e2 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -211,7 +211,6 @@ static const struct file_operations dgap_board_fops = {
 static uint dgap_numboards;
 static struct board_t *dgap_board[MAXBOARDS];
 static ulong dgap_poll_counter;
-static char *dgap_config_buf;
 static int dgap_driver_state = DRIVER_INITIALIZED;
 static wait_queue_head_t dgap_dl_wait;
 static int dgap_poll_tick = 20;	/* Poll interval - 20 ms */
@@ -823,11 +822,12 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 	const struct firmware *fw;
 	char *tmp_ptr;
 	int ret;
+	char *dgap_config_buf;
 
 	dgap_get_vpd(brd);
 	dgap_do_reset_board(brd);
 
-	if ((fw_info[card_type].conf_name) && !dgap_config_buf) {
+	if (fw_info[card_type].conf_name) {
 		ret = request_firmware(&fw, fw_info[card_type].conf_name,
 					 &pdev->dev);
 		if (ret) {
-- 
1.7.1

