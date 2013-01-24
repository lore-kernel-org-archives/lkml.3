Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3AXDbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:31:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44355 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab3AXDar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean-Christian de Rivaz <jc@eclis.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 50/74] Add CDC-ACM support for the CX93010-2x UCMxx USB Modem
Date: Thu, 24 Jan 2013 01:27:02 -0200
Message-Id: <1358998046-613-51-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Christian de Rivaz <jc@eclis.ch>

commit e7d491a19d3e3aac544070293891a2542ae0c565 upstream.

This USB V.92/V.32bis Controllered Modem have the USB vendor ID 0x0572
and device ID 0x1340. It need the NO_UNION_NORMAL quirk to be recognized.

Reference:
http://www.conexant.com/servlets/DownloadServlet/DSH-201723-005.pdf?docid=1725&revid=5
See idVendor and idProduct in table 6-1. Device Descriptors

Signed-off-by: Jean-Christian de Rivaz <jc@eclis.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index d8104c4..3850ca6 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1599,6 +1599,9 @@ static const struct usb_device_id acm_ids[] = {
 					   Maybe we should define a new
 					   quirk for this. */
 	},
+	{ USB_DEVICE(0x0572, 0x1340), /* Conexant CX93010-2x UCMxx */
+	.driver_info = NO_UNION_NORMAL,
+	},
 	{ USB_DEVICE(0x1bbb, 0x0003), /* Alcatel OT-I650 */
 	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
 	},
-- 
1.7.9.5

