Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaIXNuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:50:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51565 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbaIXNub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:50:31 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-bc-5422cc24966a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v7 2/5] amba: Add helpers for (un)preparing AMBA clock
Date: Wed, 24 Sep 2014 15:50:09 +0200
Message-id: <1411566612-32277-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
References: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xy7oqZ5RCDKZf5rDYOGM9q8X0qRcY
	LVZP/ctqceDPDkaL1y8MLc42vWG3WDJ5PqvFrCl7mSwWti1hsbi8aw6bxefeI4wWty/zWqw9
	cpfd4t3LCIu7p46yWby9M53F4szpS6wWE35fYLM4vjbc4mXffhYHEY+W5h42j80rtDwW73nJ
	5HHn2h42jyVvDrF6bLnazuIx++4PRo++LasYPVas/s7u8XmTnMfez79ZArijuGxSUnMyy1KL
	9O0SuDJePJ7BVnCHvaLvzT/WBsYjbF2MHBwSAiYS61dwdTFyApliEhfurQcKc3EICSxllJj6
	bB4rhNPHJDGr8y8zSBWbgLHE5uVLwKpEBI6wSDy79wTMYRY4yigxvfctE0iVsICbxJSevewg
	NouAqsTh/snsIOt4Bdwl1s5IhFgnJ3Hy2GRWkDCngIfE261aIGEhoIq+3udsExh5FzAyrGIU
	TS1NLihOSs811CtOzC0uzUvXS87P3cQIiYQvOxgXH7M6xCjAwajEwztBXClEiDWxrLgy9xCj
	BAezkgjvoVNAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzrzprOYFg279bBmul3LnYlPll4Kv+X
	UkHfypshUpy/WZ4rzVTZb7E7Qir877qrEs95L529Me/bfP/fSr3rtKp7GxxMohXmbXtrUNdU
	9pHN75HVb86johlrHe74MOfxbN14eNev92ZnN66uNrivqmJU/2Kb74kZV+wf6ERU/AsQ4pzI
	Wmr+82KIEktxRqKhFnNRcSIAVmGCD2ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add amba_pclk_prepare() and amba_pclk_unprepare() inline functions for
handling the AMBA bus clock by device drivers.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/amba/bus.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index fdd7e1b61f60..bb352d0bd737 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -92,6 +92,16 @@ void amba_release_regions(struct amba_device *);
 #define amba_pclk_disable(d)	\
 	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
 
+static inline void amba_pclk_prepare(struct amba_device *dev)
+{
+	clk_prepare(dev->pclk);
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

