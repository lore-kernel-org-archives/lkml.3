Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaBGLvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42085 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaBGLu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bing Zhao <bzhao@marvell.com>, "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 141/233] mwifiex: fix wrong 11ac bits setting in fw_cap_info
Date: Fri,  7 Feb 2014 11:46:00 +0000
Message-Id: <1391773652-25214-142-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 1e202242ee1432d68a8bea4919b2ae0ef19d9e06 upstream.

bit 14 is actually reserved and bit 12 & 13 should be used for
11ac capability in fw_cap_info.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/fw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 1b45aa5..f2cf3dc 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -228,7 +228,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 /* HW_SPEC fw_cap_info */
 
-#define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & (BIT(13)|BIT(14)))
+#define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & (BIT(12)|BIT(13)))
 
 #define GET_VHTCAP_CHWDSET(vht_cap_info)    ((vht_cap_info >> 2) & 0x3)
 #define GET_VHTNSSMCS(mcs_mapset, nss) ((mcs_mapset >> (2 * (nss - 1))) & 0x3)
-- 
1.8.3.2

