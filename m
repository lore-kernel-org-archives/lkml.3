Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab3HTJmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:42:33 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39998 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3HTJma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:42:30 -0400
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Kumar Gaurav <kumargauravgupta3@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20xHCI=3AFixing=20xhci=5Freadl=20definition=20and=20function=20call?=
Date: Tue, 20 Aug 2013 15:12:15 +0530
Message-Id: <1376991736-8516-1-git-send-email-kumargauravgupta3@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing other programs in xhci driver which calls this function
Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
---
 drivers/usb/host/xhci-dbg.c  |   36 +++++++--------
 drivers/usb/host/xhci-hub.c  |   72 +++++++++++++++---------------
 drivers/usb/host/xhci-mem.c  |   20 ++++-----
 drivers/usb/host/xhci-ring.c |   12 ++---
 drivers/usb/host/xhci.c      |  100 +++++++++++++++++++++---------------------
 drivers/usb/host/xhci.h      |    3 +-
 6 files changed, 121 insertions(+), 122 deletions(-)

diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
index 5d5e58f..66dc1c0 100644
--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -32,7 +32,7 @@ void xhci_dbg_regs(struct xhci_hcd *xhci)
 
 	xhci_dbg(xhci, "// xHCI capability registers at %p:\n",
 			xhci->cap_regs);
-	temp = xhci_readl(xhci, &xhci->cap_regs->hc_capbase);
+	temp = xhci_readl(&xhci->cap_regs->hc_capbase);
 	xhci_dbg(xhci, "// @%p = 0x%x (CAPLENGTH AND HCIVERSION)\n",
 			&xhci->cap_regs->hc_capbase, temp);
 	xhci_dbg(xhci, "//   CAPLENGTH: 0x%x\n",
@@ -44,13 +44,13 @@ void xhci_dbg_regs(struct xhci_hcd *xhci)
 
 	xhci_dbg(xhci, "// xHCI operational registers at %p:\n", xhci->op_regs);
 
-	temp = xhci_readl(xhci, &xhci->cap_regs->run_regs_off);
+	temp = xhci_readl(&xhci->cap_regs->run_regs_off);
 	xhci_dbg(xhci, "// @%p = 0x%x RTSOFF\n",
 			&xhci->cap_regs->run_regs_off,
 			(unsigned int) temp & RTSOFF_MASK);
 	xhci_dbg(xhci, "// xHCI runtime registers at %p:\n", xhci->run_regs);
 
-	temp = xhci_readl(xhci, &xhci->cap_regs->db_off);
+	temp = xhci_readl(&xhci->cap_regs->db_off);
 	xhci_dbg(xhci, "// @%p = 0x%x DBOFF\n", &xhci->cap_regs->db_off, temp);
 	xhci_dbg(xhci, "// Doorbell array at %p:\n", xhci->dba);
 }
@@ -61,7 +61,7 @@ static void xhci_print_cap_regs(struct xhci_hcd *xhci)
 
 	xhci_dbg(xhci, "xHCI capability registers at %p:\n", xhci->cap_regs);
 
-	temp = xhci_readl(xhci, &xhci->cap_regs->hc_capbase);
+	temp = xhci_readl(&xhci->cap_regs->hc_capbase);
 	xhci_dbg(xhci, "CAPLENGTH AND HCIVERSION 0x%x:\n",
 			(unsigned int) temp);
 	xhci_dbg(xhci, "CAPLENGTH: 0x%x\n",
@@ -69,7 +69,7 @@ static void xhci_print_cap_regs(struct xhci_hcd *xhci)
 	xhci_dbg(xhci, "HCIVERSION: 0x%x\n",
 			(unsigned int) HC_VERSION(temp));
 
-	temp = xhci_readl(xhci, &xhci->cap_regs->hcs_params1);
+	temp = xhci_readl(&xhci->cap_regs->hcs_params1);
 	xhci_dbg(xhci, "HCSPARAMS 1: 0x%x\n",
 			(unsigned int) temp);
 	xhci_dbg(xhci, "  Max device slots: %u\n",
@@ -79,7 +79,7 @@ static void xhci_print_cap_regs(struct xhci_hcd *xhci)
 	xhci_dbg(xhci, "  Max ports: %u\n",
 			(unsigned int) HCS_MAX_PORTS(temp));
 
-	temp = xhci_readl(xhci, &xhci->cap_regs->hcs_params2);
+	temp = xhci_readl(&xhci->cap_regs->hcs_params2);
 	xhci_dbg(xhci, "HCSPARAMS 2: 0x%x\n",
 			(unsigned int) temp);
 	xhci_dbg(xhci, "  Isoc scheduling threshold: %u\n",
@@ -87,7 +87,7 @@ static void xhci_print_cap_regs(struct xhci_hcd *xhci)
 	xhci_dbg(xhci, "  Maximum allowed segments in event ring: %u\n",
 			(unsigned int) HCS_ERST_MAX(temp));
 
-	temp = xhci_readl(xhci, &xhci->cap_regs->hcs_params3);
+	temp = xhci_readl(&xhci->cap_regs->hcs_params3);
 	xhci_dbg(xhci, "HCSPARAMS 3 0x%x:\n",
 			(unsigned int) temp);
 	xhci_dbg(xhci, "  Worst case U1 device exit latency: %u\n",
@@ -95,14 +95,14 @@ static void xhci_print_cap_regs(struct xhci_hcd *xhci)
 	xhci_dbg(xhci, "  Worst case U2 device exit latency: %u\n",
 			(unsigned int) HCS_U2_LATENCY(temp));
 
-	temp = xhci_readl(xhci, &xhci->cap_regs->hcc_params);
+	temp = xhci_readl(&xhci->cap_regs->hcc_params);
 	xhci_dbg(xhci, "HCC PARAMS 0x%x:\n", (unsigned int) temp);
 	xhci_dbg(xhci, "  HC generates %s bit addresses\n",
 			HCC_64BIT_ADDR(temp) ? "64" : "32");
 	/* FIXME */
 	xhci_dbg(xhci, "  FIXME: more HCCPARAMS debugging\n");
 
-	temp = xhci_readl(xhci, &xhci->cap_regs->run_regs_off);
+	temp = xhci_readl(&xhci->cap_regs->run_regs_off);
 	xhci_dbg(xhci, "RTSOFF 0x%x:\n", temp & RTSOFF_MASK);
 }
 
@@ -110,7 +110,7 @@ static void xhci_print_command_reg(struct xhci_hcd *xhci)
 {
 	u32 temp;
 
-	temp = xhci_readl(xhci, &xhci->op_regs->command);
+	temp = xhci_readl(&xhci->op_regs->command);
 	xhci_dbg(xhci, "USBCMD 0x%x:\n", temp);
 	xhci_dbg(xhci, "  HC is %s\n",
 			(temp & CMD_RUN) ? "running" : "being stopped");
@@ -128,7 +128,7 @@ static void xhci_print_status(struct xhci_hcd *xhci)
 {
 	u32 temp;
 
-	temp = xhci_readl(xhci, &xhci->op_regs->status);
+	temp = xhci_readl(&xhci->op_regs->status);
 	xhci_dbg(xhci, "USBSTS 0x%x:\n", temp);
 	xhci_dbg(xhci, "  Event ring is %sempty\n",
 			(temp & STS_EINT) ? "not " : "");
@@ -163,7 +163,7 @@ static void xhci_print_ports(struct xhci_hcd *xhci)
 		for (j = 0; j < NUM_PORT_REGS; ++j) {
 			xhci_dbg(xhci, "%p port %s reg = 0x%x\n",
 					addr, names[j],
-					(unsigned int) xhci_readl(xhci, addr));
+					(unsigned int) xhci_readl(addr));
 			addr++;
 		}
 	}
@@ -177,7 +177,7 @@ void xhci_print_ir_set(struct xhci_hcd *xhci, int set_num)
 	u64 temp_64;
 
 	addr = &ir_set->irq_pending;
-	temp = xhci_readl(xhci, addr);
+	temp = xhci_readl(addr);
 	if (temp == XHCI_INIT_VALUE)
 		return;
 
@@ -187,17 +187,17 @@ void xhci_print_ir_set(struct xhci_hcd *xhci, int set_num)
 			(unsigned int)temp);
 
 	addr = &ir_set->irq_control;
-	temp = xhci_readl(xhci, addr);
+	temp = xhci_readl(addr);
 	xhci_dbg(xhci, "  %p: ir_set.control = 0x%x\n", addr,
 			(unsigned int)temp);
 
 	addr = &ir_set->erst_size;
-	temp = xhci_readl(xhci, addr);
+	temp = xhci_readl(addr);
 	xhci_dbg(xhci, "  %p: ir_set.erst_size = 0x%x\n", addr,
 			(unsigned int)temp);
 
 	addr = &ir_set->rsvd;
-	temp = xhci_readl(xhci, addr);
+	temp = xhci_readl(addr);
 	if (temp != XHCI_INIT_VALUE)
 		xhci_dbg(xhci, "  WARN: %p: ir_set.rsvd = 0x%x\n",
 				addr, (unsigned int)temp);
@@ -219,12 +219,12 @@ void xhci_print_run_regs(struct xhci_hcd *xhci)
 	int i;
 
 	xhci_dbg(xhci, "xHCI runtime registers at %p:\n", xhci->run_regs);
-	temp = xhci_readl(xhci, &xhci->run_regs->microframe_index);
+	temp = xhci_readl(&xhci->run_regs->microframe_index);
 	xhci_dbg(xhci, "  %p: Microframe index = 0x%x\n",
 			&xhci->run_regs->microframe_index,
 			(unsigned int) temp);
 	for (i = 0; i < 7; ++i) {
-		temp = xhci_readl(xhci, &xhci->run_regs->rsvd[i]);
+		temp = xhci_readl(&xhci->run_regs->rsvd[i]);
 		if (temp != XHCI_INIT_VALUE)
 			xhci_dbg(xhci, "  WARN: %p: Rsvd[%i] = 0x%x\n",
 					&xhci->run_regs->rsvd[i],
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 1d35459..c0198af 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -93,7 +93,7 @@ static void xhci_usb2_hub_descriptor(struct usb_hcd *hcd, struct xhci_hcd *xhci,
 	 */
 	memset(port_removable, 0, sizeof(port_removable));
 	for (i = 0; i < ports; i++) {
-		portsc = xhci_readl(xhci, xhci->usb2_ports[i]);
+		portsc = xhci_readl(xhci->usb2_ports[i]);
 		/* If a device is removable, PORTSC reports a 0, same as in the
 		 * hub descriptor DeviceRemovable bits.
 		 */
@@ -147,7 +147,7 @@ static void xhci_usb3_hub_descriptor(struct usb_hcd *hcd, struct xhci_hcd *xhci,
 	port_removable = 0;
 	/* bit 0 is reserved, bit 1 is for port 1, etc. */
 	for (i = 0; i < ports; i++) {
-		portsc = xhci_readl(xhci, xhci->usb3_ports[i]);
+		portsc = xhci_readl(xhci->usb3_ports[i]);
 		if (portsc & PORT_DEV_REMOVE)
 			port_removable |= 1 << (i + 1);
 	}
@@ -342,7 +342,7 @@ static void xhci_disable_port(struct usb_hcd *hcd, struct xhci_hcd *xhci,
 
 	/* Write 1 to disable the port */
 	xhci_writel(xhci, port_status | PORT_PE, addr);
-	port_status = xhci_readl(xhci, addr);
+	port_status = xhci_readl(addr);
 	xhci_dbg(xhci, "disable port, actual port %d status  = 0x%x\n",
 			wIndex, port_status);
 }
@@ -388,7 +388,7 @@ static void xhci_clear_port_change_bit(struct xhci_hcd *xhci, u16 wValue,
 	}
 	/* Change bits are all write 1 to clear */
 	xhci_writel(xhci, port_status | status, addr);
-	port_status = xhci_readl(xhci, addr);
+	port_status = xhci_readl(addr);
 	xhci_dbg(xhci, "clear port %s change, actual port %d status  = 0x%x\n",
 			port_change_bit, wIndex, port_status);
 }
@@ -414,7 +414,7 @@ void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
 {
 	u32 temp;
 
-	temp = xhci_readl(xhci, port_array[port_id]);
+	temp = xhci_readl(port_array[port_id]);
 	temp = xhci_port_state_to_neutral(temp);
 	temp &= ~PORT_PLS_MASK;
 	temp |= PORT_LINK_STROBE | link_state;
@@ -426,7 +426,7 @@ static void xhci_set_remote_wake_mask(struct xhci_hcd *xhci,
 {
 	u32 temp;
 
-	temp = xhci_readl(xhci, port_array[port_id]);
+	temp = xhci_readl(port_array[port_id]);
 	temp = xhci_port_state_to_neutral(temp);
 
 	if (wake_mask & USB_PORT_FEAT_REMOTE_WAKE_CONNECT)
@@ -453,7 +453,7 @@ void xhci_test_and_clear_bit(struct xhci_hcd *xhci, __le32 __iomem **port_array,
 {
 	u32 temp;
 
-	temp = xhci_readl(xhci, port_array[port_id]);
+	temp = xhci_readl(port_array[port_id]);
 	if (temp & port_bit) {
 		temp = xhci_port_state_to_neutral(temp);
 		temp |= port_bit;
@@ -583,12 +583,12 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		/* Set the U1 and U2 exit latencies. */
 		memcpy(buf, &usb_bos_descriptor,
 				USB_DT_BOS_SIZE + USB_DT_USB_SS_CAP_SIZE);
-		temp = xhci_readl(xhci, &xhci->cap_regs->hcs_params3);
+		temp = xhci_readl(&xhci->cap_regs->hcs_params3);
 		buf[12] = HCS_U1_LATENCY(temp);
 		put_unaligned_le16(HCS_U2_LATENCY(temp), &buf[13]);
 
 		/* Indicate whether the host has LTM support. */
-		temp = xhci_readl(xhci, &xhci->cap_regs->hcc_params);
+		temp = xhci_readl(&xhci->cap_regs->hcc_params);
 		if (HCC_LTC(temp))
 			buf[8] |= USB_LTM_SUPPORT;
 
@@ -599,7 +599,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			goto error;
 		wIndex--;
 		status = 0;
-		temp = xhci_readl(xhci, port_array[wIndex]);
+		temp = xhci_readl(port_array[wIndex]);
 		if (temp == 0xffffffff) {
 			retval = -ENODEV;
 			break;
@@ -709,7 +709,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		if (!wIndex || wIndex > max_ports)
 			goto error;
 		wIndex--;
-		temp = xhci_readl(xhci, port_array[wIndex]);
+		temp = xhci_readl(port_array[wIndex]);
 		if (temp == 0xffffffff) {
 			retval = -ENODEV;
 			break;
@@ -718,7 +718,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		/* FIXME: What new port features do we need to support? */
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 			if ((temp & PORT_PLS_MASK) != XDEV_U0) {
 				/* Resume the port to U0 first */
 				xhci_set_link_state(xhci, port_array, wIndex,
@@ -731,7 +731,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			 * a port unless the port reports that it is in the
 			 * enabled (PED = ‘1’,PLS < ‘3’) state.
 			 */
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 			if ((temp & PORT_PE) == 0 || (temp & PORT_RESET)
 				|| (temp & PORT_PLS_MASK) >= XDEV_U3) {
 				xhci_warn(xhci, "USB core suspending device "
@@ -756,11 +756,11 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			msleep(10); /* wait device to enter */
 			spin_lock_irqsave(&xhci->lock, flags);
 
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 			bus_state->suspended_ports |= 1 << wIndex;
 			break;
 		case USB_PORT_FEAT_LINK_STATE:
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 
 			/* Disable port */
 			if (link_state == USB_SS_PORT_LS_SS_DISABLED) {
@@ -775,7 +775,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 					PORT_CEC;
 				xhci_writel(xhci, temp | PORT_PE,
 					port_array[wIndex]);
-				temp = xhci_readl(xhci, port_array[wIndex]);
+				temp = xhci_readl(port_array[wIndex]);
 				break;
 			}
 
@@ -784,7 +784,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				xhci_dbg(xhci, "Enable port %d\n", wIndex);
 				xhci_set_link_state(xhci, port_array, wIndex,
 						link_state);
-				temp = xhci_readl(xhci, port_array[wIndex]);
+				temp = xhci_readl(port_array[wIndex]);
 				break;
 			}
 
@@ -818,7 +818,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			msleep(20); /* wait device to enter */
 			spin_lock_irqsave(&xhci->lock, flags);
 
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 			if (link_state == USB_SS_PORT_LS_U3)
 				bus_state->suspended_ports |= 1 << wIndex;
 			break;
@@ -832,7 +832,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			xhci_writel(xhci, temp | PORT_POWER,
 					port_array[wIndex]);
 
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 			xhci_dbg(xhci, "set port power, actual port %d status  = 0x%x\n", wIndex, temp);
 
 			spin_unlock_irqrestore(&xhci->lock, flags);
@@ -847,13 +847,13 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			temp = (temp | PORT_RESET);
 			xhci_writel(xhci, temp, port_array[wIndex]);
 
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 			xhci_dbg(xhci, "set port reset, actual port %d status  = 0x%x\n", wIndex, temp);
 			break;
 		case USB_PORT_FEAT_REMOTE_WAKE_MASK:
 			xhci_set_remote_wake_mask(xhci, port_array,
 					wIndex, wake_mask);
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 			xhci_dbg(xhci, "set port remote wake mask, "
 					"actual port %d status  = 0x%x\n",
 					wIndex, temp);
@@ -862,12 +862,12 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			temp |= PORT_WR;
 			xhci_writel(xhci, temp, port_array[wIndex]);
 
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 			break;
 		case USB_PORT_FEAT_U1_TIMEOUT:
 			if (hcd->speed != HCD_USB3)
 				goto error;
-			temp = xhci_readl(xhci, port_array[wIndex] + PORTPMSC);
+			temp = xhci_readl(port_array[wIndex] + PORTPMSC);
 			temp &= ~PORT_U1_TIMEOUT_MASK;
 			temp |= PORT_U1_TIMEOUT(timeout);
 			xhci_writel(xhci, temp, port_array[wIndex] + PORTPMSC);
@@ -875,7 +875,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		case USB_PORT_FEAT_U2_TIMEOUT:
 			if (hcd->speed != HCD_USB3)
 				goto error;
-			temp = xhci_readl(xhci, port_array[wIndex] + PORTPMSC);
+			temp = xhci_readl(port_array[wIndex] + PORTPMSC);
 			temp &= ~PORT_U2_TIMEOUT_MASK;
 			temp |= PORT_U2_TIMEOUT(timeout);
 			xhci_writel(xhci, temp, port_array[wIndex] + PORTPMSC);
@@ -884,13 +884,13 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			goto error;
 		}
 		/* unblock any posted writes */
-		temp = xhci_readl(xhci, port_array[wIndex]);
+		temp = xhci_readl(port_array[wIndex]);
 		break;
 	case ClearPortFeature:
 		if (!wIndex || wIndex > max_ports)
 			goto error;
 		wIndex--;
-		temp = xhci_readl(xhci, port_array[wIndex]);
+		temp = xhci_readl(port_array[wIndex]);
 		if (temp == 0xffffffff) {
 			retval = -ENODEV;
 			break;
@@ -899,7 +899,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		temp = xhci_port_state_to_neutral(temp);
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
-			temp = xhci_readl(xhci, port_array[wIndex]);
+			temp = xhci_readl(port_array[wIndex]);
 			xhci_dbg(xhci, "clear USB_PORT_FEAT_SUSPEND\n");
 			xhci_dbg(xhci, "PORTSC %04x\n", temp);
 			if (temp & PORT_RESET)
@@ -1004,7 +1004,7 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 	spin_lock_irqsave(&xhci->lock, flags);
 	/* For each port, did anything change?  If so, set that bit in buf. */
 	for (i = 0; i < max_ports; i++) {
-		temp = xhci_readl(xhci, port_array[i]);
+		temp = xhci_readl(port_array[i]);
 		if (temp == 0xffffffff) {
 			retval = -ENODEV;
 			break;
@@ -1058,7 +1058,7 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 		u32 t1, t2;
 		int slot_id;
 
-		t1 = xhci_readl(xhci, port_array[port_index]);
+		t1 = xhci_readl(port_array[port_index]);
 		t2 = xhci_port_state_to_neutral(t1);
 
 		if ((t1 & PORT_PE) && !(t1 & PORT_PLS_MASK)) {
@@ -1100,7 +1100,7 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 
 			/* Get the port power control register address. */
 			addr = port_array[port_index] + PORTPMSC;
-			tmp = xhci_readl(xhci, addr);
+			tmp = xhci_readl(addr);
 			tmp |= PORT_RWE;
 			xhci_writel(xhci, tmp, addr);
 		}
@@ -1133,7 +1133,7 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 	}
 
 	/* delay the irqs */
-	temp = xhci_readl(xhci, &xhci->op_regs->command);
+	temp = xhci_readl(&xhci->op_regs->command);
 	temp &= ~CMD_EIE;
 	xhci_writel(xhci, temp, &xhci->op_regs->command);
 
@@ -1144,7 +1144,7 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 		u32 temp;
 		int slot_id;
 
-		temp = xhci_readl(xhci, port_array[port_index]);
+		temp = xhci_readl(port_array[port_index]);
 		if (DEV_SUPERSPEED(temp))
 			temp &= ~(PORT_RWC_BITS | PORT_CEC | PORT_WAKE_BITS);
 		else
@@ -1192,20 +1192,20 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 			 * the port power control register address.
 			 */
 			addr = port_array[port_index] + PORTPMSC;
-			tmp = xhci_readl(xhci, addr);
+			tmp = xhci_readl(addr);
 			tmp &= ~PORT_RWE;
 			xhci_writel(xhci, tmp, addr);
 		}
 	}
 
-	(void) xhci_readl(xhci, &xhci->op_regs->command);
+	(void) xhci_readl(&xhci->op_regs->command);
 
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(5);
 	/* re-enable irqs */
-	temp = xhci_readl(xhci, &xhci->op_regs->command);
+	temp = xhci_readl(&xhci->op_regs->command);
 	temp |= CMD_EIE;
 	xhci_writel(xhci, temp, &xhci->op_regs->command);
-	temp = xhci_readl(xhci, &xhci->op_regs->command);
+	temp = xhci_readl(&xhci->op_regs->command);
 
 	spin_unlock_irqrestore(&xhci->lock, flags);
 	return 0;
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index df6978a..0a8aa3e 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2057,7 +2057,7 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 	}
 
 	/* Port offset and count in the third dword, see section 7.2 */
-	temp = xhci_readl(xhci, addr + 2);
+	temp = xhci_readl(addr + 2);
 	port_offset = XHCI_EXT_PORT_OFF(temp);
 	port_count = XHCI_EXT_PORT_COUNT(temp);
 	xhci_dbg(xhci, "Ext Cap %p, port offset = %u, "
@@ -2136,7 +2136,7 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 	int cap_count = 0;
 
 	addr = &xhci->cap_regs->hcc_params;
-	offset = XHCI_HCC_EXT_CAPS(xhci_readl(xhci, addr));
+	offset = XHCI_HCC_EXT_CAPS(xhci_readl(addr));
 	if (offset == 0) {
 		xhci_err(xhci, "No Extended Capability registers, "
 				"unable to set up roothub.\n");
@@ -2173,7 +2173,7 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 	/* count extended protocol capability entries for later caching */
 	do {
 		u32 cap_id;
-		cap_id = xhci_readl(xhci, tmp_addr);
+		cap_id = xhci_readl(tmp_addr);
 		if (XHCI_EXT_CAPS_ID(cap_id) == XHCI_EXT_CAPS_PROTOCOL)
 			cap_count++;
 		tmp_offset = XHCI_EXT_CAPS_NEXT(cap_id);
@@ -2187,7 +2187,7 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 	while (1) {
 		u32 cap_id;
 
-		cap_id = xhci_readl(xhci, addr);
+		cap_id = xhci_readl(addr);
 		if (XHCI_EXT_CAPS_ID(cap_id) == XHCI_EXT_CAPS_PROTOCOL)
 			xhci_add_in_port(xhci, num_ports, addr,
 					(u8) XHCI_EXT_PORT_MAJOR(cap_id),
@@ -2287,7 +2287,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
 	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
 
-	page_size = xhci_readl(xhci, &xhci->op_regs->page_size);
+	page_size = xhci_readl(&xhci->op_regs->page_size);
 	xhci_dbg(xhci, "Supported page size register = 0x%x\n", page_size);
 	for (i = 0; i < 16; i++) {
 		if ((0x1 & page_size) != 0)
@@ -2307,10 +2307,10 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	 * Program the Number of Device Slots Enabled field in the CONFIG
 	 * register with the max value of slots the HC can handle.
 	 */
-	val = HCS_MAX_SLOTS(xhci_readl(xhci, &xhci->cap_regs->hcs_params1));
+	val = HCS_MAX_SLOTS(xhci_readl(&xhci->cap_regs->hcs_params1));
 	xhci_dbg(xhci, "// xHC can handle at most %d device slots.\n",
 			(unsigned int) val);
-	val2 = xhci_readl(xhci, &xhci->op_regs->config_reg);
+	val2 = xhci_readl(&xhci->op_regs->config_reg);
 	val |= (val2 & ~HCS_SLOTS_MASK);
 	xhci_dbg(xhci, "// Setting Max device slots reg = 0x%x.\n",
 			(unsigned int) val);
@@ -2388,7 +2388,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	 */
 	xhci->cmd_ring_reserved_trbs++;
 
-	val = xhci_readl(xhci, &xhci->cap_regs->db_off);
+	val = xhci_readl(&xhci->cap_regs->db_off);
 	val &= DBOFF_MASK;
 	xhci_dbg(xhci, "// Doorbell array is located at offset 0x%x"
 			" from cap regs base addr\n", val);
@@ -2436,7 +2436,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	}
 
 	/* set ERST count with the number of entries in the segment table */
-	val = xhci_readl(xhci, &xhci->ir_set->erst_size);
+	val = xhci_readl(&xhci->ir_set->erst_size);
 	val &= ERST_SIZE_MASK;
 	val |= ERST_NUM_SEGS;
 	xhci_dbg(xhci, "// Write ERST size = %i to ir_set 0 (some bits preserved)\n",
@@ -2479,7 +2479,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	 * is necessary for allowing USB 3.0 devices to do remote wakeup from
 	 * U3 (device suspend).
 	 */
-	temp = xhci_readl(xhci, &xhci->op_regs->dev_notification);
+	temp = xhci_readl(&xhci->op_regs->dev_notification);
 	temp &= ~DEV_NOTE_MASK;
 	temp |= DEV_NOTE_FWAKE;
 	xhci_writel(xhci, temp, &xhci->op_regs->dev_notification);
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 1e57eaf..9d4128c 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -286,7 +286,7 @@ void xhci_ring_cmd_db(struct xhci_hcd *xhci)
 	xhci_dbg(xhci, "// Ding dong!\n");
 	xhci_writel(xhci, DB_VALUE_HOST, &xhci->dba->doorbell[0]);
 	/* Flush PCI posted writes */
-	xhci_readl(xhci, &xhci->dba->doorbell[0]);
+	xhci_readl(&xhci->dba->doorbell[0]);
 }
 
 static int xhci_abort_cmd_ring(struct xhci_hcd *xhci)
@@ -1648,7 +1648,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 	faked_port_index = find_faked_portnum_from_hw_portnum(hcd, xhci,
 			port_id);
 
-	temp = xhci_readl(xhci, port_array[faked_port_index]);
+	temp = xhci_readl(port_array[faked_port_index]);
 	if (hcd->state == HC_STATE_SUSPENDED) {
 		xhci_dbg(xhci, "resume root hub\n");
 		usb_hcd_resume_root_hub(hcd);
@@ -1657,7 +1657,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 	if ((temp & PORT_PLC) && (temp & PORT_PLS_MASK) == XDEV_RESUME) {
 		xhci_dbg(xhci, "port resume event for port %d\n", port_id);
 
-		temp1 = xhci_readl(xhci, &xhci->op_regs->command);
+		temp1 = xhci_readl(&xhci->op_regs->command);
 		if (!(temp1 & CMD_RUN)) {
 			xhci_warn(xhci, "xHC is not running.\n");
 			goto cleanup;
@@ -2727,7 +2727,7 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 
 	spin_lock(&xhci->lock);
 	/* Check if the xHC generated the interrupt, or the irq is shared */
-	status = xhci_readl(xhci, &xhci->op_regs->status);
+	status = xhci_readl(&xhci->op_regs->status);
 	if (status == 0xffffffff)
 		goto hw_died;
 
@@ -2756,7 +2756,7 @@ hw_died:
 	if (hcd->irq) {
 		u32 irq_pending;
 		/* Acknowledge the PCI interrupt */
-		irq_pending = xhci_readl(xhci, &xhci->ir_set->irq_pending);
+		irq_pending = xhci_readl(&xhci->ir_set->irq_pending);
 		irq_pending |= IMAN_IP;
 		xhci_writel(xhci, irq_pending, &xhci->ir_set->irq_pending);
 	}
@@ -3831,7 +3831,7 @@ int xhci_queue_isoc_tx_prepare(struct xhci_hcd *xhci, gfp_t mem_flags,
 	if (ret)
 		return ret;
 
-	start_frame = xhci_readl(xhci, &xhci->run_regs->microframe_index);
+	start_frame = xhci_readl(&xhci->run_regs->microframe_index);
 	start_frame &= 0x3fff;
 
 	urb->start_frame = start_frame;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2c49f00..9685fca 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -58,7 +58,7 @@ int xhci_handshake(struct xhci_hcd *xhci, void __iomem *ptr,
 	u32	result;
 
 	do {
-		result = xhci_readl(xhci, ptr);
+		result = xhci_readl(ptr);
 		if (result == ~(u32)0)		/* card removed */
 			return -ENODEV;
 		result &= mask;
@@ -80,11 +80,11 @@ void xhci_quiesce(struct xhci_hcd *xhci)
 	u32 mask;
 
 	mask = ~(XHCI_IRQS);
-	halted = xhci_readl(xhci, &xhci->op_regs->status) & STS_HALT;
+	halted = xhci_readl(&xhci->op_regs->status) & STS_HALT;
 	if (!halted)
 		mask &= ~CMD_RUN;
 
-	cmd = xhci_readl(xhci, &xhci->op_regs->command);
+	cmd = xhci_readl(&xhci->op_regs->command);
 	cmd &= mask;
 	xhci_writel(xhci, cmd, &xhci->op_regs->command);
 }
@@ -122,7 +122,7 @@ static int xhci_start(struct xhci_hcd *xhci)
 	u32 temp;
 	int ret;
 
-	temp = xhci_readl(xhci, &xhci->op_regs->command);
+	temp = xhci_readl(&xhci->op_regs->command);
 	temp |= (CMD_RUN);
 	xhci_dbg(xhci, "// Turn on HC, cmd = 0x%x.\n",
 			temp);
@@ -156,14 +156,14 @@ int xhci_reset(struct xhci_hcd *xhci)
 	u32 state;
 	int ret, i;
 
-	state = xhci_readl(xhci, &xhci->op_regs->status);
+	state = xhci_readl(&xhci->op_regs->status);
 	if ((state & STS_HALT) == 0) {
 		xhci_warn(xhci, "Host controller not halted, aborting reset.\n");
 		return 0;
 	}
 
 	xhci_dbg(xhci, "// Reset the HC\n");
-	command = xhci_readl(xhci, &xhci->op_regs->command);
+	command = xhci_readl(&xhci->op_regs->command);
 	command |= CMD_RESET;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
 
@@ -411,7 +411,7 @@ static void compliance_mode_recovery(unsigned long arg)
 	xhci = (struct xhci_hcd *)arg;
 
 	for (i = 0; i < xhci->num_usb3_ports; i++) {
-		temp = xhci_readl(xhci, xhci->usb3_ports[i]);
+		temp = xhci_readl(xhci->usb3_ports[i]);
 		if ((temp & PORT_PLS_MASK) == USB_SS_PORT_LS_COMP_MOD) {
 			/*
 			 * Compliance Mode Detected. Letting USB Core
@@ -540,7 +540,7 @@ static void xhci_event_ring_work(unsigned long arg)
 	xhci_dbg(xhci, "Poll event ring: %lu\n", jiffies);
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	temp = xhci_readl(xhci, &xhci->op_regs->status);
+	temp = xhci_readl(&xhci->op_regs->status);
 	xhci_dbg(xhci, "op reg status = 0x%x\n", temp);
 	if (temp == 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING) ||
 			(xhci->xhc_state & XHCI_STATE_HALTED)) {
@@ -549,7 +549,7 @@ static void xhci_event_ring_work(unsigned long arg)
 		return;
 	}
 
-	temp = xhci_readl(xhci, &xhci->ir_set->irq_pending);
+	temp = xhci_readl(&xhci->ir_set->irq_pending);
 	xhci_dbg(xhci, "ir_set 0 pending = 0x%x\n", temp);
 	xhci_dbg(xhci, "HC error bitmask = 0x%x\n", xhci->error_bitmask);
 	xhci->error_bitmask = 0;
@@ -654,19 +654,19 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg(xhci, "ERST deq = 64'h%0lx\n", (long unsigned int) temp_64);
 
 	xhci_dbg(xhci, "// Set the interrupt modulation register\n");
-	temp = xhci_readl(xhci, &xhci->ir_set->irq_control);
+	temp = xhci_readl(&xhci->ir_set->irq_control);
 	temp &= ~ER_IRQ_INTERVAL_MASK;
 	temp |= (u32) 160;
 	xhci_writel(xhci, temp, &xhci->ir_set->irq_control);
 
 	/* Set the HCD state before we enable the irqs */
-	temp = xhci_readl(xhci, &xhci->op_regs->command);
+	temp = xhci_readl(&xhci->op_regs->command);
 	temp |= (CMD_EIE);
 	xhci_dbg(xhci, "// Enable interrupts, cmd = 0x%x.\n",
 			temp);
 	xhci_writel(xhci, temp, &xhci->op_regs->command);
 
-	temp = xhci_readl(xhci, &xhci->ir_set->irq_pending);
+	temp = xhci_readl(&xhci->ir_set->irq_pending);
 	xhci_dbg(xhci, "// Enabling event ring interrupter %p by writing 0x%x to irq_pending\n",
 			xhci->ir_set, (unsigned int) ER_IRQ_ENABLE(temp));
 	xhci_writel(xhci, ER_IRQ_ENABLE(temp),
@@ -743,9 +743,9 @@ void xhci_stop(struct usb_hcd *hcd)
 		usb_amd_dev_put();
 
 	xhci_dbg(xhci, "// Disabling event ring interrupts\n");
-	temp = xhci_readl(xhci, &xhci->op_regs->status);
+	temp = xhci_readl(&xhci->op_regs->status);
 	xhci_writel(xhci, temp & ~STS_EINT, &xhci->op_regs->status);
-	temp = xhci_readl(xhci, &xhci->ir_set->irq_pending);
+	temp = xhci_readl(&xhci->ir_set->irq_pending);
 	xhci_writel(xhci, ER_IRQ_DISABLE(temp),
 			&xhci->ir_set->irq_pending);
 	xhci_print_ir_set(xhci, 0);
@@ -753,7 +753,7 @@ void xhci_stop(struct usb_hcd *hcd)
 	xhci_dbg(xhci, "cleaning up memory\n");
 	xhci_mem_cleanup(xhci);
 	xhci_dbg(xhci, "xhci_stop completed - status = %x\n",
-		    xhci_readl(xhci, &xhci->op_regs->status));
+		    xhci_readl(&xhci->op_regs->status));
 }
 
 /*
@@ -779,21 +779,21 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	xhci_cleanup_msix(xhci);
 
 	xhci_dbg(xhci, "xhci_shutdown completed - status = %x\n",
-		    xhci_readl(xhci, &xhci->op_regs->status));
+		    xhci_readl(&xhci->op_regs->status));
 }
 
 #ifdef CONFIG_PM
 static void xhci_save_registers(struct xhci_hcd *xhci)
 {
-	xhci->s3.command = xhci_readl(xhci, &xhci->op_regs->command);
-	xhci->s3.dev_nt = xhci_readl(xhci, &xhci->op_regs->dev_notification);
+	xhci->s3.command = xhci_readl(&xhci->op_regs->command);
+	xhci->s3.dev_nt = xhci_readl(&xhci->op_regs->dev_notification);
 	xhci->s3.dcbaa_ptr = xhci_read_64(xhci, &xhci->op_regs->dcbaa_ptr);
-	xhci->s3.config_reg = xhci_readl(xhci, &xhci->op_regs->config_reg);
-	xhci->s3.erst_size = xhci_readl(xhci, &xhci->ir_set->erst_size);
+	xhci->s3.config_reg = xhci_readl(&xhci->op_regs->config_reg);
+	xhci->s3.erst_size = xhci_readl(&xhci->ir_set->erst_size);
 	xhci->s3.erst_base = xhci_read_64(xhci, &xhci->ir_set->erst_base);
 	xhci->s3.erst_dequeue = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
-	xhci->s3.irq_pending = xhci_readl(xhci, &xhci->ir_set->irq_pending);
-	xhci->s3.irq_control = xhci_readl(xhci, &xhci->ir_set->irq_control);
+	xhci->s3.irq_pending = xhci_readl(&xhci->ir_set->irq_pending);
+	xhci->s3.irq_control = xhci_readl(&xhci->ir_set->irq_control);
 }
 
 static void xhci_restore_registers(struct xhci_hcd *xhci)
@@ -900,7 +900,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	/* skipped assuming that port suspend has done */
 
 	/* step 2: clear Run/Stop bit */
-	command = xhci_readl(xhci, &xhci->op_regs->command);
+	command = xhci_readl(&xhci->op_regs->command);
 	command &= ~CMD_RUN;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
 	if (xhci_handshake(xhci, &xhci->op_regs->status,
@@ -915,7 +915,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	xhci_save_registers(xhci);
 
 	/* step 4: set CSS flag */
-	command = xhci_readl(xhci, &xhci->op_regs->command);
+	command = xhci_readl(&xhci->op_regs->command);
 	command |= CMD_CSS;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
 	if (xhci_handshake(xhci, &xhci->op_regs->status,
@@ -980,7 +980,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		xhci_set_cmd_ring_deq(xhci);
 		/* step 3: restore state and start state*/
 		/* step 3: set CRS flag */
-		command = xhci_readl(xhci, &xhci->op_regs->command);
+		command = xhci_readl(&xhci->op_regs->command);
 		command |= CMD_CRS;
 		xhci_writel(xhci, command, &xhci->op_regs->command);
 		if (xhci_handshake(xhci, &xhci->op_regs->status,
@@ -989,7 +989,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 			spin_unlock_irq(&xhci->lock);
 			return -ETIMEDOUT;
 		}
-		temp = xhci_readl(xhci, &xhci->op_regs->status);
+		temp = xhci_readl(&xhci->op_regs->status);
 	}
 
 	/* If restore operation fails, re-initialize the HC during resume */
@@ -1018,9 +1018,9 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 #endif
 
 		xhci_dbg(xhci, "// Disabling event ring interrupts\n");
-		temp = xhci_readl(xhci, &xhci->op_regs->status);
+		temp = xhci_readl(&xhci->op_regs->status);
 		xhci_writel(xhci, temp & ~STS_EINT, &xhci->op_regs->status);
-		temp = xhci_readl(xhci, &xhci->ir_set->irq_pending);
+		temp = xhci_readl(&xhci->ir_set->irq_pending);
 		xhci_writel(xhci, ER_IRQ_DISABLE(temp),
 				&xhci->ir_set->irq_pending);
 		xhci_print_ir_set(xhci, 0);
@@ -1028,7 +1028,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		xhci_dbg(xhci, "cleaning up memory\n");
 		xhci_mem_cleanup(xhci);
 		xhci_dbg(xhci, "xhci_stop completed - status = %x\n",
-			    xhci_readl(xhci, &xhci->op_regs->status));
+			    xhci_readl(&xhci->op_regs->status));
 
 		/* USB core calls the PCI reinit and start functions twice:
 		 * first with the primary HCD, and then with the secondary HCD.
@@ -1057,7 +1057,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	}
 
 	/* step 4: set Run/Stop bit */
-	command = xhci_readl(xhci, &xhci->op_regs->command);
+	command = xhci_readl(&xhci->op_regs->command);
 	command |= CMD_RUN;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
 	xhci_handshake(xhci, &xhci->op_regs->status, STS_HALT,
@@ -1496,7 +1496,7 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	ret = usb_hcd_check_unlink_urb(hcd, urb, status);
 	if (ret || !urb->hcpriv)
 		goto done;
-	temp = xhci_readl(xhci, &xhci->op_regs->status);
+	temp = xhci_readl(&xhci->op_regs->status);
 	if (temp == 0xffffffff || (xhci->xhc_state & XHCI_STATE_HALTED)) {
 		xhci_dbg(xhci, "HW died, freeing TD.\n");
 		urb_priv = urb->hcpriv;
@@ -3606,7 +3606,7 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 
 	spin_lock_irqsave(&xhci->lock, flags);
 	/* Don't disable the slot if the host controller is dead. */
-	state = xhci_readl(xhci, &xhci->op_regs->status);
+	state = xhci_readl(&xhci->op_regs->status);
 	if (state == 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING) ||
 			(xhci->xhc_state & XHCI_STATE_HALTED)) {
 		xhci_free_virt_device(xhci, udev->slot_id);
@@ -4088,12 +4088,12 @@ static int xhci_usb2_software_lpm_test(struct usb_hcd *hcd,
 			PORT_L1S_MASK, PORT_L1S_SUCCESS, 125);
 	if (ret != -ETIMEDOUT) {
 		/* enter L1 successfully */
-		temp = xhci_readl(xhci, addr);
+		temp = xhci_readl(addr);
 		xhci_dbg(xhci, "port %d entered L1 state, port status 0x%x\n",
 				port_num, temp);
 		ret = 0;
 	} else {
-		temp = xhci_readl(xhci, pm_addr);
+		temp = xhci_readl(pm_addr);
 		xhci_dbg(xhci, "port %d software lpm failed, L1 status %d\n",
 				port_num, temp & PORT_L1S_MASK);
 		ret = -EINVAL;
@@ -4111,7 +4111,7 @@ static int xhci_usb2_software_lpm_test(struct usb_hcd *hcd,
 
 	/* Check PORTSC to make sure the device is in the right state */
 	if (!ret) {
-		temp = xhci_readl(xhci, addr);
+		temp = xhci_readl(addr);
 		xhci_dbg(xhci, "resumed port %d status 0x%x\n",	port_num, temp);
 		if (!(temp & PORT_CONNECT) || !(temp & PORT_PE) ||
 				(temp & PORT_PLS_MASK) != XDEV_U0) {
@@ -4169,7 +4169,7 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 	port_array = xhci->usb2_ports;
 	port_num = udev->portnum - 1;
 	pm_addr = port_array[port_num] + PORTPMSC;
-	pm_val = xhci_readl(xhci, pm_addr);
+	pm_val = xhci_readl(pm_addr);
 	hlpm_addr = port_array[port_num] + PORTHLPMC;
 	field = le32_to_cpu(udev->bos->ext_cap->bmAttributes);
 
@@ -4211,7 +4211,7 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 			hlpm_val = xhci_calculate_usb2_hw_lpm_params(udev);
 			xhci_writel(xhci, hlpm_val, hlpm_addr);
 			/* flush write */
-			xhci_readl(xhci, hlpm_addr);
+			xhci_readl(hlpm_addr);
 		} else {
 			hird = xhci_calculate_hird_besl(xhci, udev);
 		}
@@ -4219,16 +4219,16 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 		pm_val &= ~PORT_HIRD_MASK;
 		pm_val |= PORT_HIRD(hird) | PORT_RWE;
 		xhci_writel(xhci, pm_val, pm_addr);
-		pm_val = xhci_readl(xhci, pm_addr);
+		pm_val = xhci_readl(pm_addr);
 		pm_val |= PORT_HLE;
 		xhci_writel(xhci, pm_val, pm_addr);
 		/* flush write */
-		xhci_readl(xhci, pm_addr);
+		xhci_readl(pm_addr);
 	} else {
 		pm_val &= ~(PORT_HLE | PORT_RWE | PORT_HIRD_MASK);
 		xhci_writel(xhci, pm_val, pm_addr);
 		/* flush write */
-		xhci_readl(xhci, pm_addr);
+		xhci_readl(pm_addr);
 		if (udev->usb2_hw_lpm_besl_capable) {
 			spin_unlock_irqrestore(&xhci->lock, flags);
 			mutex_lock(hcd->bandwidth_mutex);
@@ -4829,7 +4829,7 @@ int xhci_get_frame(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	/* EHCI mods by the periodic size.  Why? */
-	return xhci_readl(xhci, &xhci->run_regs->microframe_index) >> 3;
+	return xhci_readl(&xhci->run_regs->microframe_index) >> 3;
 }
 
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
@@ -4866,7 +4866,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 		 * registered roothub.
 		 */
 		xhci = hcd_to_xhci(hcd);
-		temp = xhci_readl(xhci, &xhci->cap_regs->hcc_params);
+		temp = xhci_readl(&xhci->cap_regs->hcc_params);
 		if (HCC_64BIT_ADDR(temp)) {
 			xhci_dbg(xhci, "Enabling 64-bit DMA addresses.\n");
 			dma_set_mask(hcd->self.controller, DMA_BIT_MASK(64));
@@ -4878,16 +4878,16 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 
 	xhci->cap_regs = hcd->regs;
 	xhci->op_regs = hcd->regs +
-		HC_LENGTH(xhci_readl(xhci, &xhci->cap_regs->hc_capbase));
+		HC_LENGTH(xhci_readl(&xhci->cap_regs->hc_capbase));
 	xhci->run_regs = hcd->regs +
-		(xhci_readl(xhci, &xhci->cap_regs->run_regs_off) & RTSOFF_MASK);
+		(xhci_readl(&xhci->cap_regs->run_regs_off) & RTSOFF_MASK);
 	/* Cache read-only capability registers */
-	xhci->hcs_params1 = xhci_readl(xhci, &xhci->cap_regs->hcs_params1);
-	xhci->hcs_params2 = xhci_readl(xhci, &xhci->cap_regs->hcs_params2);
-	xhci->hcs_params3 = xhci_readl(xhci, &xhci->cap_regs->hcs_params3);
-	xhci->hcc_params = xhci_readl(xhci, &xhci->cap_regs->hc_capbase);
+	xhci->hcs_params1 = xhci_readl(&xhci->cap_regs->hcs_params1);
+	xhci->hcs_params2 = xhci_readl(&xhci->cap_regs->hcs_params2);
+	xhci->hcs_params3 = xhci_readl(&xhci->cap_regs->hcs_params3);
+	xhci->hcc_params = xhci_readl(&xhci->cap_regs->hc_capbase);
 	xhci->hci_version = HC_VERSION(xhci->hcc_params);
-	xhci->hcc_params = xhci_readl(xhci, &xhci->cap_regs->hcc_params);
+	xhci->hcc_params = xhci_readl(&xhci->cap_regs->hcc_params);
 	xhci_print_registers(xhci);
 
 	get_quirks(dev, xhci);
@@ -4904,7 +4904,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 		goto error;
 	xhci_dbg(xhci, "Reset complete\n");
 
-	temp = xhci_readl(xhci, &xhci->cap_regs->hcc_params);
+	temp = xhci_readl(&xhci->cap_regs->hcc_params);
 	if (HCC_64BIT_ADDR(temp)) {
 		xhci_dbg(xhci, "Enabling 64-bit DMA addresses.\n");
 		dma_set_mask(hcd->self.controller, DMA_BIT_MASK(64));
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index c338741..7cf0e41 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1598,8 +1598,7 @@ static inline struct usb_hcd *xhci_to_hcd(struct xhci_hcd *xhci)
 
 /* TODO: copied from ehci.h - can be refactored? */
 /* xHCI spec says all registers are little endian */
-static inline unsigned int xhci_readl(const struct xhci_hcd *xhci,
-		__le32 __iomem *regs)
+static inline unsigned int xhci_readl(__le32 __iomem *regs)
 {
 	return readl(regs);
 }
-- 
1.7.9.5

