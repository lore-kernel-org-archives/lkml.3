Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355AbaDVUhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:37:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbaDVUYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:24:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 038/133] usb: dwc3: fix wrong bit mask in dwc3_event_devt
Date: Tue, 22 Apr 2014 13:12:56 -0700
Message-Id: <1398197671-12786-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Rui <ray.huang@amd.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/core.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 17dcd98..7df353f 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -807,15 +807,15 @@ struct dwc3_event_depevt {
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
1.9.1

