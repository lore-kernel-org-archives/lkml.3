Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762429AbbA2Ciu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:38:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762405AbbA2Ciq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 131/139] rtlwifi: rtl8192ce: Set fw_ready flag
Date: Wed, 28 Jan 2015 14:21:14 -0800
Message-Id: <1422483682-15393-132-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9a1dce3a059111a7289680f4b8c0ec4f8736b6ee upstream.

The setting of this flag was missed in previous modifications.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 2eb0b38..24a80db 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -951,6 +951,7 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 	local_save_flags(flags);
 	local_irq_enable();
 
+	rtlhal->fw_ready = false;
 	rtlpriv->intf_ops->disable_aspm(hw);
 	rtstatus = _rtl92ce_init_mac(hw);
 	if (!rtstatus) {
@@ -967,6 +968,7 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 		goto exit;
 	}
 
+	rtlhal->fw_ready = true;
 	rtlhal->last_hmeboxnum = 0;
 	rtl92c_phy_mac_config(hw);
 	/* because last function modify RCR, so we update
-- 
1.9.1

