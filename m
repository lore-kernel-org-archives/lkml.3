Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbbASHQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:16:02 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:40518 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbASHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:13:54 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J7Do3v003940, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/7] r8152: adjust lpm timer
Date: Mon, 19 Jan 2015 15:13:32 +0800
Message-ID: <1394712342-15778-120-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-118-Taiwan-albertk@realtek.com>
References: <1394712342-15778-118-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set LPM timer to 500us, except for RTL_VER_04 which doesn't link at
USB 3.0.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 78a8917..3ee9d06 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3274,10 +3274,10 @@ static void r8153_init(struct r8152 *tp)
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_LPM_CTRL);
 	ocp_data &= ~LPM_TIMER_MASK;
-	if (tp->udev->speed == USB_SPEED_SUPER)
-		ocp_data |= LPM_TIMER_500US;
-	else
+	if (tp->version == RTL_VER_04 && tp->udev->speed != USB_SPEED_SUPER)
 		ocp_data |= LPM_TIMER_500MS;
+	else
+		ocp_data |= LPM_TIMER_500US;
 	ocp_write_byte(tp, MCU_TYPE_USB, USB_LPM_CTRL, ocp_data);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_AFE_CTRL2);
-- 
2.1.0

