Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaEOU7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:59:05 -0400
Received: from us-mx2.synaptics.com ([192.147.44.131]:17532 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaEOU7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:59:02 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 15 May 2014 14:00:37 -0700
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Andrew Duggan <aduggan@synaptics.com>
Subject: [PATCH] HID: rmi: fix masks for x and w_x data
Date: Thu, 15 May 2014 13:52:29 -0700
Message-ID: <1400187149-7619-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.2.20.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The F11 data in the HID report contains four bits of data for w_x and the least significant bits
of x. Currently only the first three bits are being used which is resulting in small jumps in
the position data on the x axis and in the w_x data.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-rmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 7ebdc96..c529b03 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -277,9 +277,9 @@ static void rmi_f11_process_touch(struct rmi_data *hdata, int slot,
 	input_mt_report_slot_state(hdata->input, MT_TOOL_FINGER,
 			finger_state == 0x01);
 	if (finger_state == 0x01) {
-		x = (touch_data[0] << 4) | (touch_data[2] & 0x07);
+		x = (touch_data[0] << 4) | (touch_data[2] & 0x0F);
 		y = (touch_data[1] << 4) | (touch_data[2] >> 4);
-		wx = touch_data[3] & 0x07;
+		wx = touch_data[3] & 0x0F;
 		wy = touch_data[3] >> 4;
 		wide = (wx > wy);
 		major = max(wx, wy);
-- 
1.9.1

