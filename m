Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3ILOTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:19:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35341 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3ILOTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:19:30 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-c5-5231cd702dab
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/6] usb: s3c-hsotg: change dependency to PLAT_SAMSUNG
Date: Thu, 12 Sep 2013 16:18:47 +0200
Message-id: <1378995532-32142-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
References: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQd2Cs4ZBBlMm2lhsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGd8u9LIX7OGo+Pp4HUsDYy97FyMnh4SAicTae0tZIWwxiQv31rN1
	MXJxCAlMZ5TY/mkuE4TTxSQx/ccRsCo2AR2JLd8nMILYIgICEutfXGIHKWIWeMIoMfXIK7Cx
	wgJuElN/QaxgEVCVWNvdDWbzCrhK/Lr9mw1inbzE0/t9YDYnUH3fbpDVHEDbXCUmbk2ZwMi7
	gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwUD2T2sG4ssHiEKMAB6MSD2/HLIMgIdbE
	suLK3EOMEhzMSiK8nycaBgnxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQ
	WgSTZeLglGpgPJn+dPbyVwLMPIvmmrizFkwuujjFov+czpudU6MnWG05I25/g2vax2Uz5bcF
	KeXM0fCxW3xTw3lC6NEFE+r1PnZpLva0KEmN/8TU3Ct6bu1tvxjGuc+iEhmuPOozrfqnUB5w
	p27dwdQQiVOcsvNinhY+CUgwsF7L3c+kvuX4rVtZWd+tAx/aKbEUZyQaajEXFScCAJbkytMm	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

On device tree based Samsung SoC platforms (like Exynos) no platform
devices are defined and CONFIG_S3C_DEV_USB_HSOTG is no longer available,
so change the driver dependency to more generic and approperiate
CONFIG_PLAT_SAMSUNG, as the driver can be used on almost all Samsung
platforms.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 8e93683..08fc9dd 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -282,7 +282,7 @@ config USB_PXA27X
 
 config USB_S3C_HSOTG
 	tristate "S3C HS/OtG USB Device controller"
-	depends on S3C_DEV_USB_HSOTG
+	depends on PLAT_SAMSUNG
 	help
 	  The Samsung S3C64XX USB2.0 high-speed gadget controller
 	  integrated into the S3C64XX series SoC.
-- 
1.7.9.5

