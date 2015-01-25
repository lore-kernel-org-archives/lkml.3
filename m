Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbbAYSvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:51:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbbAYSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.18 061/183] rtlwifi: rtl8192ce: Set fw_ready flag
Date: Sun, 25 Jan 2015 10:06:23 -0800
Message-Id: <20150125180812.836304300@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9a1dce3a059111a7289680f4b8c0ec4f8736b6ee upstream.

The setting of this flag was missed in previous modifications.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -955,6 +955,7 @@ int rtl92ce_hw_init(struct ieee80211_hw
 	local_save_flags(flags);
 	local_irq_enable();
 
+	rtlhal->fw_ready = false;
 	rtlpriv->intf_ops->disable_aspm(hw);
 	rtstatus = _rtl92ce_init_mac(hw);
 	if (!rtstatus) {
@@ -971,6 +972,7 @@ int rtl92ce_hw_init(struct ieee80211_hw
 		goto exit;
 	}
 
+	rtlhal->fw_ready = true;
 	rtlhal->last_hmeboxnum = 0;
 	rtl92c_phy_mac_config(hw);
 	/* because last function modify RCR, so we update


