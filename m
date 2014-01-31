Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaAaGfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 01:35:51 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46974 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaAaGfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 01:35:50 -0500
From: Surendra Patil <surendra.tux@gmail.com>
To: gregkh@linuxfoundation.org, aaro.koskinen@iki.fi, devendra.aaru@gmail.com
Cc: surendra.tux@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Drivers:staging:octeon-usb: Fixed Few coding style errors
Date: Thu, 30 Jan 2014 22:35:19 -0800
Message-Id: <1391150119-11109-1-git-send-email-surendra.tux@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below errors - only few listed
octeon-hcd.c:162: ERROR: spaces prohibited around that ':' (ctx:WxW)
cteon-hcd.c:249: ERROR: Macros with complex values should be enclosed in parenthesis
octeon-hcd.c:992: WARNING: braces {} are not necessary for single statement blocks
octeon-hcd.c:3228: ERROR: return is not a function, parentheses are not required

Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index 47e0a91..b25e0f8 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -159,13 +159,13 @@ enum cvmx_usb_complete {
  *			status call.
  */
 struct cvmx_usb_port_status {
-	uint32_t reserved		: 25;
-	uint32_t port_enabled		: 1;
-	uint32_t port_over_current	: 1;
-	uint32_t port_powered		: 1;
-	enum cvmx_usb_speed port_speed	: 2;
-	uint32_t connected		: 1;
-	uint32_t connect_change		: 1;
+	uint32_t reserved:25;
+	uint32_t port_enabled:1;
+	uint32_t port_over_current:1;
+	uint32_t port_powered:1;
+	enum cvmx_usb_speed port_speed:2;
+	uint32_t connected:1;
+	uint32_t connect_change:1;
 };
 
 /**
@@ -181,11 +181,11 @@ struct cvmx_usb_port_status {
 union cvmx_usb_control_header {
 	uint64_t u64;
 	struct {
-		uint64_t request_type   : 8;
-		uint64_t request        : 8;
-		uint64_t value          : 16;
-		uint64_t index          : 16;
-		uint64_t length         : 16;
+		uint64_t request_type:8;
+		uint64_t request:8;
+		uint64_t value:16;
+		uint64_t index:16;
+		uint64_t length:16;
 	} s;
 };
 
@@ -246,7 +246,7 @@ enum cvmx_usb_pipe_flags {
 };
 
 /* Normal prefetch that use the pref instruction. */
-#define CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0))
+#define CVMX_PREFETCH(address, offset) (asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0)))
 
 /* Maximum number of times to retry failed transactions */
 #define MAX_RETRIES		3
@@ -989,9 +989,8 @@ static int cvmx_usb_enable(struct cvmx_usb_state *usb)
 		return 0;
 
 	/* If there is nothing plugged into the port then fail immediately */
-	if (!usb->usbcx_hprt.s.prtconnsts) {
+	if (!usb->usbcx_hprt.s.prtconnsts)
 		return -ETIMEDOUT;
-	}
 
 	/* Program the port reset bit to start the reset process */
 	USB_SET_FIELD32(CVMX_USBCX_HPRT(usb->index), union cvmx_usbcx_hprt, prtrst, 1);
@@ -3225,7 +3224,7 @@ static int octeon_usb_hub_status_data(struct usb_hcd *hcd, char *buf)
 	buf[0] = 0;
 	buf[0] = port_status.connect_change << 1;
 
-	return (buf[0] != 0);
+	return buf[0] != 0;
 }
 
 static int octeon_usb_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex, char *buf, u16 wLength)
-- 
1.8.3.2

