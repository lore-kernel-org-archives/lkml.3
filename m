Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaIOKf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:35:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36842 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753320AbaIOKfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:35:16 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/9] usb: add support to the generic PHY framework in OTG
Date: Mon, 15 Sep 2014 12:35:03 +0200
Message-Id: <1410777309-12552-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support of the PHY framework in OTG and keeps the USB
PHY compatibility. Here the only modification is to add PHY member in
the OTG structure, along with the USB PHY one.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 include/linux/usb/otg.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 978fbbb0e266..52661c5da690 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -9,11 +9,14 @@
 #ifndef __LINUX_USB_OTG_H
 #define __LINUX_USB_OTG_H
 
+#include <linux/phy/phy.h>
 #include <linux/usb/phy.h>
 
 struct usb_otg {
 	u8			default_a;
 
+	struct phy		*phy;
+	/* old usb_phy interface */
 	struct usb_phy		*usb_phy;
 	struct usb_bus		*host;
 	struct usb_gadget	*gadget;
-- 
1.9.1

