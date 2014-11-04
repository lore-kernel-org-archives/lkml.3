Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaKDMxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:53:15 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49767 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaKDMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:53:07 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-8e-5458cc2f2c29
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v9 1/4] amba: Add helpers for (un)preparing AMBA clock
Date: Tue, 04 Nov 2014 13:52:47 +0100
Message-id: <1415105570-7871-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xq7r6ZyJCDFb81rPYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF6xeGFk83P2ayONv0ht1iyeT5rBadE5ewW8yaspfJ4vKuOWwWn3uPMFrc
	vsxrsfbIXXaLdy8jLO6eOspmceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+yOmawei/e8
	ZPLYtKqTzePOtT1sHov7JrN6LHlziNVjy9V2Fo/Zd38wevRtWcXosWL1d3aPz5vkPPZ+/s0S
	wBvFZZOSmpNZllqkb5fAlXHn72XWgqkcFRO+6TUwfmfrYuTgkBAwkfg+RamLkRPIFJO4cG89
	UJiLQ0hgKaPExylnGUESQgJ9TBIb26VAbDYBY4nNy5eAFYkIrGKReLXnOpjDLPCRUeLm6o3M
	IFXCAm4Sn6/NZgWxWQRUJeb/msEOYvMCxRtffGSCWCcncfLYZLAaTgF3ia0b97FBbHOTePPo
	DdsERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MULi48sOxsXHrA4xCnAwKvHwZqhH
	hAixJpYVV+YeYpTgYFYS4TXeDRTiTUmsrEotyo8vKs1JLT7EyMTBKdXAaMKfwM3/04Nn50We
	GUvnff1z1H5ZSNubIEkPPYObZkfaOLsdZK7M1vpdUuXHxZDAyjdh20/GSa4GK+tfGU2YHntR
	mH2GdeqvU9XL8ksv/Jh109EgW7jb6MVu5Z1xBbc4LjzUeKk+u0HXfp8OW/yWtQEb+GaFrZVw
	38Q7yWFHT8fSa+UibGsqlViKMxINtZiLihMBzSBEim0CAAA=
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
index c324f5700d1a..ac02f9bd63dc 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -97,6 +97,16 @@ void amba_release_regions(struct amba_device *);
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

