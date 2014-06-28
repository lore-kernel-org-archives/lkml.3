Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaF1GRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:17:30 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:48589 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaF1GR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:17:28 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: gdm72xx: return -EINVAL instead of BUG_ON for invalid data length
Date: Fri, 27 Jun 2014 23:17:24 -0700
Message-Id: <1403936247-24117-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes gdm_usb_send() and gdm_sdio_send() to return -EINVAL instead
of calling BUG_ON if an invalid data length is passed to the functions.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Michalis Pappas <mpappas@fastmail.fm>
Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_sdio.c | 3 ++-
 drivers/staging/gdm72xx/gdm_usb.c  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index 0c6a3eb..9d2de6f 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -390,7 +390,8 @@ static int gdm_sdio_send(void *priv_dev, void *data, int len,
 	u16 cmd_evt;
 	unsigned long flags;
 
-	BUG_ON(len > TX_BUF_SIZE - TYPE_A_HEADER_SIZE);
+	if (len > TX_BUF_SIZE - TYPE_A_HEADER_SIZE)
+		return -EINVAL;
 
 	spin_lock_irqsave(&tx->lock, flags);
 
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index cd8e6e4..971976c 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -312,7 +312,8 @@ static int gdm_usb_send(void *priv_dev, void *data, int len,
 		return -ENODEV;
 	}
 
-	BUG_ON(len > TX_BUF_SIZE - padding - 1);
+	if (len > TX_BUF_SIZE - padding - 1)
+		return -EINVAL;
 
 	spin_lock_irqsave(&tx->lock, flags);
 
-- 
2.0.0.526.g5318336

