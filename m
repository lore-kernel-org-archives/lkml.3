Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaIVJss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:48:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62961 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaIVJq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:46:57 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-1c-541ff00e38d3
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
Subject: [PATCH v6 2/4] amba: Add helper macros for (un)preparing AMBA clock
Date: Mon, 22 Sep 2014 11:46:27 +0200
Message-id: <1411379189-3017-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411379189-3017-1-git-send-email-k.kozlowski@samsung.com>
References: <1411379189-3017-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7p8H+RDDPoP21hsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLN7emc5iceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+YVWh6L97xk
	8rhzbQ+bx5I3h1g9tlxtZ/GYffcHo0ffllWMHitWf2f3+LxJzmPv598sAdxRXDYpqTmZZalF
	+nYJXBl7Dx9kKTjAXnHp4UumBsY1bF2MnBwSAiYSfzZ+YYWwxSQu3FsPFOfiEBJYyijR0vCS
	GcLpY5J49riJHaSKTcBYYvPyJWBVIgJHWCSe3XsC5jALHGWUmN77lgmkSljAR+LVjR6gDg4O
	FgFVibl9MiBhXgE3iUtTprBArJOTOHlsMthqTgF3if3PWsAWCAHVHDk0m2kCI+8CRoZVjKKp
	pckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHR8GUH4+JjVocYBTgYlXh4FzTJhwixJpYVV+YeYpTg
	YFYS4X36HCjEm5JYWZValB9fVJqTWnyIkYmDU6qBcfPMwiNu6fPrbso1S2Wt95PpXyi8QvHk
	LbGCvWGJMwOmq5TUZtR//6Gz89dxlpI+yebQu9N3usdtlr29Qmh3ctCe232FguW/SxpDXywR
	5+jMuvLUNcCpWfqLgmPggVWPlq2U+ld/8qvvmoM5050LPokd/ZltKTSHffJU7n6z76suRqwz
	SzkYpsRSnJFoqMVcVJwIAIfCFfxkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add amba_pclk_prepare() and amba_pclk_unprepare() macros for handling
the AMBA bus clock by device drivers.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/amba/bus.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index fdd7e1b61f60..ad52027a9cbf 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -92,6 +92,12 @@ void amba_release_regions(struct amba_device *);
 #define amba_pclk_disable(d)	\
 	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
 
+#define amba_pclk_prepare(d)	\
+	(IS_ERR((d)->pclk) ? 0 : clk_prepare((d)->pclk))
+
+#define amba_pclk_unprepare(d)	\
+	do { if (!IS_ERR((d)->pclk)) clk_unprepare((d)->pclk); } while (0)
+
 /* Some drivers don't use the struct amba_device */
 #define AMBA_CONFIG_BITS(a) (((a) >> 24) & 0xff)
 #define AMBA_REV_BITS(a) (((a) >> 20) & 0x0f)
-- 
1.9.1

