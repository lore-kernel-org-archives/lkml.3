Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbbAEJpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:45:01 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22684 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAEJpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:45:00 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-00-54aa5d1a4b91
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: mina86@mina86.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] tools: ffs-aio-example: add missing wMaxPacketSize for HS descs
Date: Mon, 05 Jan 2015 10:44:44 +0100
Message-id: <1420451084-27430-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t9jAV2p2FUhBi8WCFkcvF9vcXnXHDaL
	RctamS0WHG9htXhweCe7A6vHuj+vmDz6tqxi9Dh+YzuTx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	r/vvMhe8Ya/YtHc1WwPjCbYuRk4OCQETiQNLp0DZYhIX7q0Hsrk4hAQWMUpM2DwDymlnkph7
	4A1YFZuAjsSW7xMYQWwRAQGJ9S8usYPYzAIVElMfNoHVCAsESJy8d5wZxGYRUJU4cbmTCcTm
	FXCVWPl5P9Q2OYmTxyazTmDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOAyeSe9g
	XNVgcYhRgINRiYfX48TKECHWxLLiytxDjBIczEoivOtuAYV4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzKtm3hQgJpCeWpGanphakFsFkmTg4pRoYfVhbzn6fO/Hl1wWFnquPVbJc6937qDBx5fXc
	SWyLFs9g0NMrDuGb1bBgW+efrC3xT9/6/5YJPSIjkLzjuYxPWHJs7Y+5xnbembut+Le6rX8/
	78EBjyUVr7K+n4z0W5g6rUh+x5+bB0r9X7SW2gpapBww8b0aMemqN0vuuX2hqeF73332c1xn
	osRSnJFoqMVcVJwIAP6bCwb/AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's needed, to have more than 64 bytes of maxpacketsize.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 tools/usb/ffs-aio-example/simple/device_app/aio_simple.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/usb/ffs-aio-example/simple/device_app/aio_simple.c b/tools/usb/ffs-aio-example/simple/device_app/aio_simple.c
index adc310a..1f44a29 100644
--- a/tools/usb/ffs-aio-example/simple/device_app/aio_simple.c
+++ b/tools/usb/ffs-aio-example/simple/device_app/aio_simple.c
@@ -103,12 +103,14 @@ static const struct {
 			.bDescriptorType = USB_DT_ENDPOINT,
 			.bEndpointAddress = 1 | USB_DIR_IN,
 			.bmAttributes = USB_ENDPOINT_XFER_BULK,
+			.wMaxPacketSize = htole16(512),
 		},
 		.bulk_source = {
 			.bLength = sizeof(descriptors.hs_descs.bulk_source),
 			.bDescriptorType = USB_DT_ENDPOINT,
 			.bEndpointAddress = 2 | USB_DIR_OUT,
 			.bmAttributes = USB_ENDPOINT_XFER_BULK,
+			.wMaxPacketSize = htole16(512),
 		},
 	},
 };
-- 
1.9.1

