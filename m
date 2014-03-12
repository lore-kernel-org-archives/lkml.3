Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaCLMkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:40:52 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45400 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaCLMk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:40:26 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2CCeNoe010846, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH net-next 2/2] r8152: reduce the numbers of the bulks
Date: Wed, 12 Mar 2014 20:39:59 +0800
Message-ID: <1394628023-12713-2-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1394526259-5513-2-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
 <1394526259-5513-2-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not necessary to have many transfer buffers. Reduce the number
from 10 to 4.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0c43b28..9ff7501 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -419,8 +419,8 @@ enum rtl_register_content {
 	FULL_DUP	= 0x01,
 };
 
-#define RTL8152_MAX_TX		10
-#define RTL8152_MAX_RX		10
+#define RTL8152_MAX_TX		4
+#define RTL8152_MAX_RX		4
 #define INTBUFSIZE		2
 #define CRC_SIZE		4
 #define TX_ALIGN		4
-- 
1.8.4.2

