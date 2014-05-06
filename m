Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbaEFAT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:19:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41462 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757224AbaEFAOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:14:33 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 04/20] usb: xhci: add a platform-private field
Date: Tue,  6 May 2014 02:13:59 +0200
Message-Id: <1399335255-589-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an xhci->priv field for private use by xHCI platform
drivers. This field was present for OHCI and EHCI and it was not
needed until now for xHCI. With the introduction of the clock support,
then a private field will be useful, so let's mimic what have been
done for the other HCI.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/usb/host/xhci.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index d280e9213d08..054017f66246 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1584,6 +1584,9 @@ struct xhci_hcd {
 	u32			port_status_u0;
 /* Compliance Mode Timer Triggered every 2 seconds */
 #define COMP_MODE_RCVRY_MSECS 2000
+
+	/* platform-specific data -- must come last */
+	unsigned long		priv[0] __aligned(sizeof(s64));
 };
 
 /* convert between an HCD pointer and the corresponding EHCI_HCD */
-- 
1.8.1.2

