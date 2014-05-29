Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451AbaE2F1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:27:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbaE2EfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 054/140] wl18xx: align event mailbox with current fw
Date: Wed, 28 May 2014 21:33:13 -0700
Message-Id: <20140529043056.386213076@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit c0da71ff4d2cbf113465bff9a7c413154be25a89 upstream.

Some fields are missing from the event mailbox
struct definitions, which cause issues when
trying to handle some events.

Add the missing fields in order to align the
struct size (without adding actual support
for the new fields).

Reported-and-tested-by: Imre Kaloz <kaloz@openwrt.org>
Fixes: 028e724 ("wl18xx: move to new firmware (wl18xx-fw-3.bin)")
Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ti/wl18xx/event.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/net/wireless/ti/wl18xx/event.h
+++ b/drivers/net/wireless/ti/wl18xx/event.h
@@ -68,6 +68,26 @@ struct wl18xx_event_mailbox {
 
 	/* bitmap of inactive stations (by HLID) */
 	__le32 inactive_sta_bitmap;
+
+	/* rx BA win size indicated by RX_BA_WIN_SIZE_CHANGE_EVENT_ID */
+	u8 rx_ba_role_id;
+	u8 rx_ba_link_id;
+	u8 rx_ba_win_size;
+	u8 padding;
+
+	/* smart config */
+	u8 sc_ssid_len;
+	u8 sc_pwd_len;
+	u8 sc_token_len;
+	u8 padding1;
+	u8 sc_ssid[32];
+	u8 sc_pwd[32];
+	u8 sc_token[32];
+
+	/* smart config sync channel */
+	u8 sc_sync_channel;
+	u8 sc_sync_band;
+	u8 padding2[2];
 } __packed;
 
 int wl18xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,


