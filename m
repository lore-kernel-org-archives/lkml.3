Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaIPNAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:00:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30519 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaIPM7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:59:37 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-b7-54183436badc
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
Subject: [PATCH v5 2/4] amba: Add helper macros for (un)preparing AMBA clock
Date: Tue, 16 Sep 2014 14:59:18 +0200
Message-id: <1410872360-27029-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410872360-27029-1-git-send-email-k.kozlowski@samsung.com>
References: <1410872360-27029-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xK7pmJhIhBitua1tsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLN7emc5iceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+YVWh6L97xk
	8rhzbQ+bx5I3h1g9tlxtZ/GYffcHo0ffllWMHitWf2f3+LxJzmPv598sAdxRXDYpqTmZZalF
	+nYJXBl7Dx9kKTjAXnHp4UumBsY1bF2MnBwSAiYSTQv2MEPYYhIX7q0HinNxCAksZZQ4t/c3
	E4TTxyTx4/xcsA42AWOJzcuXgFWJCBxhkXh27wmYwyxwlFFieu9bJpAqYQEfibdfb4PNZRFQ
	lZizYR9YN6+Au8S22wuYIPbJSZw8NpkVxOYU8JC4vvcaWL0QUM3NqROYJzDyLmBkWMUomlqa
	XFCclJ5rqFecmFtcmpeul5yfu4kREg9fdjAuPmZ1iFGAg1GJhzfjn3iIEGtiWXFl7iFGCQ5m
	JRFeD02JECHelMTKqtSi/Pii0pzU4kOMTBycUg2MQdKXHvy8Vno6IPvIko74trSyoN2l7A78
	vMKub9IXdXlybkvodl41d8H+3dyTLDxutEUIP3110TS8cU70uT7+rG4/ziOf112Jia9YcuCO
	V772jv9VoUnTMrMVChmkW74/set8XfTqyV+hl807HmxnDgoQ9j5/79WLQ1uU13zt3lf3Y8oT
	xo4yJZbijERDLeai4kQA4ArUhmUCAAA=
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

