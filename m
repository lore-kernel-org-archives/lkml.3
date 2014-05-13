Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbaEMJkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:40:41 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60903 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760108AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 097/182] usb: dwc3: fix wrong bit mask in dwc3_event_devt
Date: Tue, 13 May 2014 11:27:29 +0200
Message-Id: <d4e408428c6fdb32e6bbab3032ba82e1c7aeaff4.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 06f9b6e59661cee510b04513b13ea7927727d758 upstream.

Around DWC USB3 2.30a release another bit has been added to the
Device-Specific Event (DEVT) Event Information (EvtInfo) bitfield.

Because of that, what used to be 8 bits long, has become 9 bits long.

Per dwc3 2.30a+ spec in the Device-Specific Event (DEVT), the field of
Event Information Bits(EvtInfo) uses [24:16] bits, and it has 9 bits
not 8 bits. And the following reserved field uses [31:25] bits not
[31:24] bits, and it has 7 bits.

So in dwc3_event_devt, the bit mask should be:
event_info	[24:16]		9 bits
reserved31_25	[31:25]		7 bits

This patch makes sure that newer core releases will work fine with
Linux and that we will decode the event information properly on new
core releases.

[ balbi@ti.com : improve commit log a bit ]

Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/dwc3/core.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index f8af8d44af85..69c4583933d1 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -815,15 +815,15 @@ struct dwc3_event_depevt {
  *	12	- VndrDevTstRcved
  * @reserved15_12: Reserved, not used
  * @event_info: Information about this event
- * @reserved31_24: Reserved, not used
+ * @reserved31_25: Reserved, not used
  */
 struct dwc3_event_devt {
 	u32	one_bit:1;
 	u32	device_event:7;
 	u32	type:4;
 	u32	reserved15_12:4;
-	u32	event_info:8;
-	u32	reserved31_24:8;
+	u32	event_info:9;
+	u32	reserved31_25:7;
 } __packed;
 
 /**
-- 
1.9.3

