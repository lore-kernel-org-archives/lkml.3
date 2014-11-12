Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaKLOcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:32:43 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63658 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaKLOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:32:37 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-a0-54636f8234b0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v11 2/6] amba: Add helpers for (un)preparing AMBA clock
Date: Wed, 12 Nov 2014 15:32:24 +0100
Message-id: <1415802748-30530-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xq7pN+ckhBkfemFlsnLGe1WL61AuM
	Fqun/mW1eP3C0OLp5sdMFmeb3rBbdE5cwm4xa8peJovLu+awWXzuPcJocfsyr8XaI3fZLe6e
	Ospmceb0JVaLCb8vsFkcXxtu8bJvP4uDoEdLcw+bx+yOmawei/e8ZPLYtKqTzePOtT1sHluu
	trN4zL77g9Gjb8sqRo8Vq7+ze3zeJBfAFcVlk5Kak1mWWqRvl8CVMefyNtaCqRwVWz+dZW9g
	/M7WxcjBISFgItG1J62LkRPIFJO4cG89UJiLQ0hgKaPE9pY9zBBOH5PEmtMbWUCq2ASMJTYv
	XwJWJSLQzizRt24qG0iCWWARk0TTVEUQW1jAXeL93ylMIDaLgKrE/2XzwJp5geITv5xghFgn
	J3Hy2GRWEJtTwEPiy7a/YHOEgGrOXD7IMoGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT8
	3E2MkDD/soNx8TGrQ4wCHIxKPLwVPMkhQqyJZcWVuYcYJTiYlUR4d+UAhXhTEiurUovy44tK
	c1KLDzEycXBKNTC6PDQViw6wP3swuVS685KFkLJCmsGlmWHOch0TLBc3bmE2NVljI2T5SHSa
	8I+mN31Oz6ep2Lx8pXOmtvzWzXLlT7P5EzqzexhYf02NnLrziPGjpzopZwQ3ThEpMJaZsEjk
	bs/fEOXlZg/y2yKv16woUdcyeqrUen6jh+IVGdMU51eh3OHSgUosxRmJhlrMRcWJAOuXDzdR	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add amba_pclk_prepare() and amba_pclk_unprepare() inline functions for
handling the AMBA bus clock by device drivers.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 include/linux/amba/bus.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index d024bd9c9d9b..2afc618b15ce 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -98,6 +98,16 @@ void amba_release_regions(struct amba_device *);
 #define amba_pclk_disable(d)	\
 	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
 
+static inline int amba_pclk_prepare(struct amba_device *dev)
+{
+	return clk_prepare(dev->pclk);
+}
+
+static inline void amba_pclk_unprepare(struct amba_device *dev)
+{
+	clk_unprepare(dev->pclk);
+}
+
 /* Some drivers don't use the struct amba_device */
 #define AMBA_CONFIG_BITS(a) (((a) >> 24) & 0xff)
 #define AMBA_REV_BITS(a) (((a) >> 20) & 0x0f)
-- 
1.9.1

