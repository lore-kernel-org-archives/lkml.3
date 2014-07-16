Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbaGPKXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:23:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18062 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735AbaGPKX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:27 -0400
X-AuditID: cbfee61b-f79f86d00000144c-66-53c6528f25f2
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 08/12] usb: dwc2/gadget: do not call disconnect method in
 pullup
Date: Wed, 16 Jul 2014 12:22:26 +0200
Message-id: <1405506150-16185-9-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd3+oGPBBncnSlrMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wW26dMZ7J4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKOHPzIEvBPLaKK01XWRoYF7F2MXJySAiYSCw8uIkdwhaT
	uHBvPVsXIxeHkMB0Rok1j9ZAOe1MEj9PXwTrYBPQkdjyfQIjiC0iICCx/sUldpAiZoETjBId
	/y+wgSSEBUIlln48yAxiswioSrTOagRr4BVwlVjTfA5qnZzEyWOTwYZyCrhJrHndDBYXAqo5
	vm4Z0wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxggPsmfQOxlUNFocYBTgYlXh4
	N4QcDRZiTSwrrsw9xCjBwawkwuvgfyxYiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0
	xJLU7NTUgtQimCwTB6dUA+Pm3vlhWvvWaS5o9BHwv+5S/Cp636xfxz+ujzki38dz40cXR8Va
	ljb71qjWVZOnn7n/8K5W80Kxomlhn9bERjIVu//oPh5e57AxNaeOxWHa1JlPzY61bdpmd6Ru
	2b7JTCbrBF81rg3hs7ec13HPrMs/o5JpyoQws6habk6NCX+3qNQHlJ/fVqfEUpyRaKjFXFSc
	CACgibI7LAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This leads to potential spinlock recursion in composite framework, other
udc drivers also don't call it directly from pullup method.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 2220882..def4900 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2945,7 +2945,6 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 		s3c_hsotg_phy_enable(hsotg);
 		s3c_hsotg_core_init(hsotg);
 	} else {
-		s3c_hsotg_disconnect(hsotg);
 		s3c_hsotg_phy_disable(hsotg);
 	}
 
-- 
1.9.1

