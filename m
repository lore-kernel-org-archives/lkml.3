Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaLaIqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:46:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40853 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaLaIpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:45:55 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] phy-sun4i-usb: Change disconnect threshold value for sun6i
Date: Wed, 31 Dec 2014 14:15:48 +0530
Message-ID: <1420015549-20697-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420015549-20697-1-git-send-email-kishon@ti.com>
References: <1420015549-20697-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

The allwinner SDK uses a value of 3 for the disconnect threshold setting on
sun6i, do the same in the kernel.

In my previous experience with sun5i problems getting the threshold right
is important to avoid usb2 devices being unplugged sometimes going unnoticed.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-sun4i-usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index fb02a67..a2b08f3c 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -244,7 +244,8 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 	else
 		data->num_phys = 3;
 
-	if (of_device_is_compatible(np, "allwinner,sun4i-a10-usb-phy"))
+	if (of_device_is_compatible(np, "allwinner,sun4i-a10-usb-phy") ||
+	    of_device_is_compatible(np, "allwinner,sun6i-a31-usb-phy"))
 		data->disc_thresh = 3;
 	else
 		data->disc_thresh = 2;
-- 
1.7.9.5

