Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3LRF4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:56:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59497 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3LRF43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:56:29 -0500
From: Wenliang Fan <fanwlexca@gmail.com>
To: j@w1.fi, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wenliang Fan <fanwlexca@gmail.com>
Subject: [PATCH] drivers/net/wireless/hostap: Integer overflow
Date: Wed, 18 Dec 2013 13:56:12 +0800
Message-Id: <1387346172-27863-1-git-send-email-fanwlexca@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local variable 'value' comes from 'extra', a parameter of function
'prism2_ioctl_priv_prism2_param'. If a large number passed to 'value',
there would be an integer overflow in the following line:
	local->passive_scan_timer.expires = jiffies +
		local->passive_scan_interval * HZ

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
---
 drivers/net/wireless/hostap/hostap_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index e509030..63e350a 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -2567,7 +2567,7 @@ static int prism2_ioctl_priv_prism2_param(struct net_device *dev,
 		local->passive_scan_interval = value;
 		if (timer_pending(&local->passive_scan_timer))
 			del_timer(&local->passive_scan_timer);
-		if (value > 0) {
+		if (value > 0 && value < INT_MAX / HZ) {
 			local->passive_scan_timer.expires = jiffies +
 				local->passive_scan_interval * HZ;
 			add_timer(&local->passive_scan_timer);
-- 
1.8.5.rc1.28.g7061504

