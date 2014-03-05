Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaCEGvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:51:40 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:58021 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbaCEGuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:50:16 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s256oDKD009581, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 12/13] r8152: add additional parameter for non x86 platform
Date: Wed, 5 Mar 2014 14:49:27 +0800
Message-ID: <1394002168-3193-13-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1394002168-3193-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
 <1394002168-3193-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add additional parameter for non x86 platform for better throughput.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ddb5200..6c0ec37 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -313,7 +313,11 @@
 #define PCUT_STATUS		0x0001
 
 /* USB_RX_EARLY_AGG */
-#define EARLY_AGG_SUPPER	0x0e832981
+#if defined(__i386__) || defined(__x86_64__)
+	#define EARLY_AGG_SUPPER	0x0e832981
+#else
+	#define EARLY_AGG_SUPPER	0x0e835000
+#endif
 #define EARLY_AGG_HIGH		0x0e837a12
 #define EARLY_AGG_SLOW		0x0e83ffff
 
-- 
1.8.4.2

