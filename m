Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbaE3KHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:07:35 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62287 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaE3KHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:07:33 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: gregkh@linuxfoundation.org
Cc: gulsah.1004@gmail.com, pavel@ucw.cz, pali.rohar@gmail.com,
        peter.p.waskiewicz.jr@intel.com, cmroliv@gmail.com,
        kristina.martsenko@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range() instead of msleep()
Date: Fri, 30 May 2014 11:27:13 +0100
Message-Id: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creating this patch for the Eudyptula Challenge.
Replaced msleep() for a delay < 20ms with a usleep_range() between 10000us and 15000us.
Also inserted a blank line after adeclaration.

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/nokia_h4p/nokia_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 5e19cd6..ba0506d 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -724,7 +724,7 @@ static int hci_h4p_reset(struct hci_h4p_info *info)

	gpio_set_value(info->reset_gpio, 0);
	gpio_set_value(info->bt_wakeup_gpio, 1);
-	msleep(10);
+	usleep_range(10000, 15000);

	if (gpio_get_value(info->host_wakeup_gpio) == 1) {
		dev_err(info->dev, "host_wakeup_gpio not low\n");
@@ -756,6 +756,7 @@ static int hci_h4p_reset(struct hci_h4p_info *info)
static int hci_h4p_hci_flush(struct hci_dev *hdev)
{
	struct hci_h4p_info *info = hci_get_drvdata(hdev);
+
	skb_queue_purge(&info->txq);

	return 0;
--
1.7.10.4

