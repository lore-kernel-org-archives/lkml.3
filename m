Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaD1Bcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42970 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Huang Rui" <ray.huang@amd.com>,
        "Felipe Balbi" <balbi@ti.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.394483812@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 32/94] usb: dwc3: fix wrong bit mask in dwc3_event_devt
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/core.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -716,15 +716,15 @@ struct dwc3_event_depevt {
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

