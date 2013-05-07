Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab3EGNkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42009 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144Ab3EGNkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 001/118] ath9k_htc: accept 1.x firmware newer than 1.3
Date: Tue,  7 May 2013 14:37:27 +0100
Message-Id: <1367933964-1564-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 319e7bd96aca64a478f3aad40711c928405b8b77 upstream.

Since the firmware has been open sourced, the minor version has been
bumped to 1.4 and the API/ABI will stay compatible across further 1.x
releases.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 25213d5..21c280b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -774,7 +774,7 @@ static int ath9k_init_firmware_version(struct ath9k_htc_priv *priv)
 	 * required version.
 	 */
 	if (priv->fw_version_major != MAJOR_VERSION_REQ ||
-	    priv->fw_version_minor != MINOR_VERSION_REQ) {
+	    priv->fw_version_minor < MINOR_VERSION_REQ) {
 		dev_err(priv->dev, "ath9k_htc: Please upgrade to FW version %d.%d\n",
 			MAJOR_VERSION_REQ, MINOR_VERSION_REQ);
 		return -EINVAL;
-- 
1.8.1.2

