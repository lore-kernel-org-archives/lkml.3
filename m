Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab3CLK2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:28:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50571 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab3CLK0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:26:13 -0400
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 1/6] mfd: omap-usb-host: update nports in platform_data
Date: Tue, 12 Mar 2013 12:25:35 +0200
Message-ID: <1363083940-20050-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363083940-20050-1-git-send-email-rogerq@ti.com>
References: <1363083940-20050-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EHCI driver would need to know the number of ports available
on the platform. We set the nports parameter of platform_data
based on IP version if it was not already provided.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
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

