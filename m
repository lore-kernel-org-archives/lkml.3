Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3AXJFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:05:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44061 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3AXJFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:05:21 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <mturquette@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@ti.com>
Subject: [PATCH v10 20/20] mfd: omap-usb-host: get rid of build warning
Date: Thu, 24 Jan 2013 11:04:56 +0200
Message-ID: <1359018296-5015-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20130123233617.9205.88295@quantum>
References: <20130123233617.9205.88295@quantum>
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
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index b21ca76..6b5edf6 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -791,7 +791,7 @@ static struct platform_driver usbhs_omap_driver = {
 		.owner		= THIS_MODULE,
 		.pm		= &usbhsomap_dev_pm_ops,
 	},
-	.remove		= __exit_p(usbhs_omap_remove),
+	.remove		= usbhs_omap_remove,
 };
 
 MODULE_AUTHOR("Keshava Munegowda <keshava_mgowda@ti.com>");
-- 
1.7.4.1

