Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbaBDN2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:28:12 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49060 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbaBDN2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:28:10 -0500
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] usb: musb: host: Fix SuperSpeed hub enumeration
Date: Tue, 4 Feb 2014 15:28:06 +0200
Message-ID: <1391520486-26298-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391520349-26192-1-git-send-email-rogerq@ti.com>
References: <1391520349-26192-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajay Kumar Gupta <ajay.gupta@ti.com>

Disables PING on status phase of control transfer.
PING token is not mandatory in status phase of control transfer
and so some high speed USB devices don't support it. If such devices
are connected to MUSB then they would not respond to PING token
causing delayed or failed enumeration.

[Roger Q] Fixes enumeration issues with some Super-Speed USB hubs
e.g. Dlink DUB-1340

Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/musb/musb_host.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index ed45572..abb38c3 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1183,6 +1183,9 @@ irqreturn_t musb_h_ep0_irq(struct musb *musb)
 				csr = MUSB_CSR0_H_STATUSPKT
 					| MUSB_CSR0_TXPKTRDY;
 
+			/* disable ping token in status phase */
+			csr |= MUSB_CSR0_H_DIS_PING;
+
 			/* flag status stage */
 			musb->ep0_stage = MUSB_EP0_STATUS;
 
-- 
1.8.3.2

