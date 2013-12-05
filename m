Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3LELWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:22:06 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:48484 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3LELWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:22:03 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 1/2] usb: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 19:21:32 +0800
Message-ID: <1386242492-25480-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI standard marco dev_is_pci() instead of directly compare
pci_bus_type to check whether it is pci device.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/usb/host/ehci-dbg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 4a9c2ed..0bb5e48 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -818,7 +818,7 @@ static ssize_t fill_registers_buffer(struct debug_buffer *buf)
 
 #ifdef	CONFIG_PCI
 	/* EHCI 0.96 and later may have "extended capabilities" */
-	if (hcd->self.controller->bus == &pci_bus_type) {
+	if (dev_is_pci(hcd->self.controller)) {
 		struct pci_dev	*pdev;
 		u32		offset, cap, cap2;
 		unsigned	count = 256/4;
-- 
1.7.1


