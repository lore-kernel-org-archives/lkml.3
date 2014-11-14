Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaKNIur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:50:47 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57110 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbaKNIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:50:43 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-f3-5465c260411f
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
Subject: [PATCH v12 2/6] amba: Add helpers for (un)preparing AMBA clock
Date: Fri, 14 Nov 2014 09:50:29 +0100
Message-id: <1415955033-29093-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
References: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xy7oJh1JDDJ52slhsnLGe1WL61AuM
	Fqun/mW1eP3C0OLp5sdMFmeb3rBbdE5cwm4xa8peJovLu+awWXzuPcJocfsyr8XaI3fZLe6e
	Ospmceb0JVaLCb8vsFkcXxtu8bJvP4uDoEdLcw+bx+yOmawei/e8ZPLYtKqTzePOtT1sHluu
	trN4zL77g9Gjb8sqRo8Vq7+ze3zeJBfAFcVlk5Kak1mWWqRvl8CVMefyNtaCqRwVWz+dZW9g
	/M7WxcjJISFgItE+rw/KFpO4cG89kM3FISSwlFHiUvtFRginj0li68d9jCBVbALGEpuXLwGr
	EhFoZ5boWzcVrJ1ZYBGTRNNURRBbWMBd4sjHf2ANLAKqEp9OTQCr4QWKn2j4yQKxTk7i5LHJ
	rCA2p4CHxOSNq8DiQkA1ny//YZ7AyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkig
	f9nBuPiY1SFGAQ5GJR5eg4LUECHWxLLiytxDjBIczEoivEq7gUK8KYmVValF+fFFpTmpxYcY
	mTg4pRoY5xml/g01384x5cF6ubZ50h2RiQo3Ha2Vj83M6zf4vdAxOWJ32IqVL5e+qt9vIMvC
	zDSjWSr7kt4lhWNzt70SC56x8Nr7dYG/uqSvSzeeeP2NaeWje/fT37HbKcVuV2Wrf2zs/DCM
	1aVN4H+v1GOd6sh81zlPvk5bKbzMS3nS2xTv8yy1B8JLlViKMxINtZiLihMBMQTq61ICAAA=
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

