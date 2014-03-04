Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaCDITK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:19:10 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39642 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaCDITI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:19:08 -0500
From: Surendra Patil <surendra.tux@gmail.com>
To: linville@tuxdriver.com
Cc: pavel@ucw.cz, pali.rohar@gmail.com, david.gnedt@davizone.at,
        surendra.tux@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Drivers:net:wireless:ti:wl1251: Fixed Sparse invalid assignment warning
Date: Tue,  4 Mar 2014 00:18:52 -0800
Message-Id: <1393921132-15950-1-git-send-email-surendra.tux@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse warns about invalid assignment in
drivers/net/wireless/ti/wl1251/cmd.c:451:42: warning: invalid assignment: |=
drivers/net/wireless/ti/wl1251/cmd.c:451:42:    left side has type restricted __le16
drivers/net/wireless/ti/wl1251/cmd.c:451:42:    right side has type int
Hence type converted right side to __le16.

Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
---
 drivers/net/wireless/ti/wl1251/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index 223649b..bf1fa18 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -448,7 +448,7 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 	 * Note: This bug may be caused by the fw's DTIM handling.
 	 */
 	if (is_zero_ether_addr(wl->bssid))
-		cmd->params.scan_options |= WL1251_SCAN_OPT_PRIORITY_HIGH;
+		cmd->params.scan_options |= cpu_to_le16(WL1251_SCAN_OPT_PRIORITY_HIGH);
 	cmd->params.num_channels = n_channels;
 	cmd->params.num_probe_requests = n_probes;
 	cmd->params.tx_rate = cpu_to_le16(1 << 1); /* 2 Mbps */
-- 
1.8.3.2

