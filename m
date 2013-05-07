Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab3EGEdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:33:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab3EGEZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:54 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qQEgKN5ckkwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=R1ybqqyDiYsA:10 a=jdP34snFAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=9mtjllxcxZAA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035853.775139774@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [077/126] ath9k_htc: accept 1.x firmware newer than 1.3
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0077-ath9k_htc-accept-1.x-firmware-newer-than-1.3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

[ Upstream commit 319e7bd96aca64a478f3aad40711c928405b8b77 ]

Since the firmware has been open sourced, the minor version has been
bumped to 1.4 and the API/ABI will stay compatible across further 1.x
releases.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a035a38..01248b9 100644
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
1.7.10.4


