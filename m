Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaGFQNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:13:24 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37650 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaGFQNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:13:18 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 4/4] Staging: rts5208: Fix a format specifier for dev_err
Date: Sun,  6 Jul 2014 18:12:18 +0200
Message-Id: <1404663138-21333-5-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an incorrect use of the %d format specifier in dev_err that caused a 
warning.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5208/rtsx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 4f5f7a3..9aae7ac 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -463,14 +463,14 @@ static int rtsx_control_thread(void *__dev)
 		 * the maximum known LUN
 		 */
 		else if (chip->srb->device->id) {
-			dev_err(&dev->pci->dev, "Bad target number (%d:%d)\n",
+			dev_err(&dev->pci->dev, "Bad target number (%d:%llu)\n",
 				chip->srb->device->id,
 				chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
 		else if (chip->srb->device->lun > chip->max_lun) {
-			dev_err(&dev->pci->dev, "Bad LUN (%d:%d)\n",
+			dev_err(&dev->pci->dev, "Bad LUN (%d:%llu)\n",
 				chip->srb->device->id,
 				chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
-- 
2.0.0

