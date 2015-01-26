Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbbAZPjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:39:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41374 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbAZPjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:39:33 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: navin.patidar@gmail.com, Larry.Finger@lwfinger.net,
        dan.carpenter@oracle.com, tapaswenipathak@gmail.com,
        abelmoyo.ab@gmail.com, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: core: rtw_wlan_util.c: Fix for NULL dereference
Date: Mon, 26 Jan 2015 16:39:14 +0100
Message-Id: <1422286754-3039-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rtw_check_bcn_info(), check the return value of kzalloc() before
dereferencing it, to avoid NULL pointer dereference.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index 3e9b6e9..a3ffc69 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -931,6 +931,8 @@ int rtw_check_bcn_info(struct adapter  *Adapter, u8 *pframe, u32 packet_len)
 	}
 
 	bssid = kzalloc(sizeof(struct wlan_bssid_ex), GFP_ATOMIC);
+	if (!bssid)
+		return _FAIL;
 
 	subtype = GetFrameSubType(pframe) >> 4;
 
-- 
2.1.0

