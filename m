Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3DVOlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:41:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51584 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887Ab3DVOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felix Fietkau" <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.712324803@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [44/75] ath9k_htc: accept 1.x firmware newer than 1.3
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 319e7bd96aca64a478f3aad40711c928405b8b77 upstream.

Since the firmware has been open sourced, the minor version has been
bumped to 1.4 and the API/ABI will stay compatible across further 1.x
releases.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -801,7 +801,7 @@ static int ath9k_init_firmware_version(s
 	 * required version.
 	 */
 	if (priv->fw_version_major != MAJOR_VERSION_REQ ||
-	    priv->fw_version_minor != MINOR_VERSION_REQ) {
+	    priv->fw_version_minor < MINOR_VERSION_REQ) {
 		dev_err(priv->dev, "ath9k_htc: Please upgrade to FW version %d.%d\n",
 			MAJOR_VERSION_REQ, MINOR_VERSION_REQ);
 		return -EINVAL;

