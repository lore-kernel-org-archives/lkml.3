Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3A1LbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:31:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49606 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab3A1LbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:01 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 07/30] mfd: omap-usb-host: update nports in platform_data
Date: Mon, 28 Jan 2013 13:30:08 +0200
Message-ID: <1359372631-8180-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EHCI driver would need to know the number of ports available
on the platform. We set the nports parameter of platform_data
based on IP version if it was not already provided.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/omap-usb-host.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 6b5edf6..0874352 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -575,6 +575,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 			 omap->usbhs_rev, omap->nports);
 			break;
 		}
+		pdata->nports = omap->nports;
 	}
 
 	i = sizeof(struct clk *) * omap->nports;
-- 
1.7.4.1

