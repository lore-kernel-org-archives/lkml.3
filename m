Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbaBGLsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaBGLss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 052/233] rtlwifi: rtl8192c: Add routines to save/restore power index registers
Date: Fri,  7 Feb 2014 11:44:31 +0000
Message-Id: <1391773652-25214-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 97204e93f01868eeba6ae5c4f3270f32905bb418 upstream.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 36 +++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index d2d57a2..06cb94c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -158,6 +158,42 @@ static const u8 cckswing_table_ch14[CCK_TABLE_SIZE][8] = {
 	{0x09, 0x08, 0x07, 0x04, 0x00, 0x00, 0x00, 0x00}
 };
 
+static u32 power_index_reg[6] = {0xc90, 0xc91, 0xc92, 0xc98, 0xc99, 0xc9a};
+
+void dm_restorepowerindex(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8	index;
+
+	for (index = 0; index < 6; index++)
+		rtl_write_byte(rtlpriv, power_index_reg[index],
+			       rtlpriv->dm.powerindex_backup[index]);
+}
+EXPORT_SYMBOL_GPL(dm_restorepowerindex);
+
+void dm_writepowerindex(struct ieee80211_hw *hw, u8 value)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 index;
+
+	for (index = 0; index < 6; index++)
+		rtl_write_byte(rtlpriv, power_index_reg[index], value);
+}
+EXPORT_SYMBOL_GPL(dm_writepowerindex);
+
+void dm_savepowerindex(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 index;
+	u8 tmp;
+
+	for (index = 0; index < 6; index++) {
+		tmp = rtl_read_byte(rtlpriv, power_index_reg[index]);
+		rtlpriv->dm.powerindex_backup[index] = tmp;
+	}
+}
+EXPORT_SYMBOL_GPL(dm_savepowerindex);
+
 static void rtl92c_dm_diginit(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-- 
1.8.3.2

