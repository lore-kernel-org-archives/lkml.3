Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab3CDVRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:17:03 -0500
Received: from mout.gmx.net ([212.227.17.21]:53410 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434Ab3CDVRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:17:00 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/kl8o3MU/kf2nQu3BKNSYqVu+9TgIaXO0mlbm2PL
	4AJE8x4y5U6CVx
From: Peter Huewe <peterhuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>, Kent Yoder <shpedoikal@gmail.com>
Subject: [PATCH] tpm/tpm_i2c_infineon: Add small comment about return value of __i2c_transfer
Date: Mon,  4 Mar 2013 22:17:15 +0100
Message-Id: <1362431835-21443-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.12.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Yoder indicated that the code might be a bit clearer with a comment
here, so this patch adds a small explanation of the code.

CC: Kent Yoder <shpedoikal@gmail.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_i2c_infineon.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index d83bb8c..37d5dcc 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -162,6 +162,10 @@ out:
 	/* take care of 'guard time' */
 	usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
 
+	/* __i2c_transfer returns the number of successfully transferred
+	 * messages.
+	 * So rc should be greater than 0 here otherwise we have an error.
+	 */
 	if (rc <= 0)
 		return -EIO;
 
@@ -208,6 +212,11 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
 	i2c_unlock_adapter(tpm_dev.client->adapter);
 	/* take care of 'guard time' */
 	usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
+
+	/* __i2c_transfer returns the number of successfully transferred
+	 * messages.
+	 * So rc should be greater than 0 here otherwise we have an error.
+	 */
 	if (rc <= 0)
 		return -EIO;
 
-- 
1.7.12.4

