Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3AQLbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:31:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42786 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab3AQLbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:31:49 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v7 22/22] mdf: omap-usb-host: get rid of build warning
Date: Thu, 17 Jan 2013 13:30:31 +0200
Message-ID: <1358422231-24736-23-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358422231-24736-1-git-send-email-rogerq@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the below build warning when driver is built-in.

drivers/mfd/omap-usb-host.c:750:12: warning:
‘usbhs_omap_remove’ defined but not used [-Wunused-function]

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index a1f73dc..b726a74 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -778,7 +778,7 @@ static struct platform_driver usbhs_omap_driver = {
 		.owner		= THIS_MODULE,
 		.pm		= &usbhsomap_dev_pm_ops,
 	},
-	.remove		= __exit_p(usbhs_omap_remove),
+	.remove		= usbhs_omap_remove,
 };
 
 MODULE_AUTHOR("Keshava Munegowda <keshava_mgowda@ti.com>");
-- 
1.7.4.1

