Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078Ab3FCQOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:14:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36451 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759038Ab3FCQOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:14:20 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>,
        <benoit.cousson@linaro.org>, <anish198519851985@gmail.com>,
        <pmeerw@pmeerw.net>, Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 3/5] extcon: add EXPORT_SYMBOL_GPL for exported functions
Date: Mon, 3 Jun 2013 21:43:38 +0530
Message-ID: <1370276020-17446-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370276020-17446-1-git-send-email-kishon@ti.com>
References: <1370276020-17446-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added EXPORT_SYMBOL_GPL() for extcon_register_interest and
extcon_register_notifier in order to avoid undefined reference
error when building the consumer modules of extcon as _modules_.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/extcon/extcon-class.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 265d549..51a5f5f 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -541,6 +541,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 		return -ENODEV;
 	}
 }
+EXPORT_SYMBOL_GPL(extcon_register_interest);
 
 /**
  * extcon_unregister_interest() - Unregister the notifier registered by
@@ -555,6 +556,7 @@ int extcon_unregister_interest(struct extcon_specific_cable_nb *obj)
 
 	return raw_notifier_chain_unregister(&obj->edev->nh, &obj->internal_nb);
 }
+EXPORT_SYMBOL_GPL(extcon_unregister_interest);
 
 /**
  * extcon_register_notifier() - Register a notifiee to get notified by
-- 
1.7.10.4

