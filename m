Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaIXNwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:52:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59103 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaIXNuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:50:35 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-76-5422cc26bb26
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
Subject: [PATCH v7 5/5] amba: Remove unused amba_pclk_enable/disable macros
Date: Wed, 24 Sep 2014 15:50:12 +0200
Message-id: <1411566612-32277-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
References: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xy7pqZ5RCDN506lhsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLN7emc5iceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+YVWh6L97xk
	8rhzbQ+bx5I3h1g9tlxtZ/GYffcHo0ffllWMHitWf2f3+LxJzmPv598sAdxRXDYpqTmZZalF
	+nYJXBm3mgUKlrBXPFp3nr2BcSZbFyMnh4SAicSj9UfYIWwxiQv31gPFuTiEBJYySjQte80O
	4fQxSZzpnMUCUsUmYCyxefkSsCoRgSMsEs/uPQFzmAWOMkpM733LBFIlLOAt8fP6RaB2Dg4W
	AVWJY7sDQcK8Au4Sj34vYoFYJydx8thkVpASTgEPibdbtUDCQkAlfb3P2SYw8i5gZFjFKJpa
	mlxQnJSea6RXnJhbXJqXrpecn7uJERIJX3cwLj1mdYhRgINRiYd3orhSiBBrYllxZe4hRgkO
	ZiUR3kOngEK8KYmVValF+fFFpTmpxYcYmTg4pRoYl6y+0qDz68nZ/05d9xM9JmiyHHiYZ/nG
	oU/5acKGF19sw7uljrH8XNC8vz77x5sCiR5vzy89VtslDBY6ha7P1DRiXsLRz3d2Od+DuIJT
	25v5FLZMiO0TC+CwuL3Y7f1sXV/5SckrfFwWvQhZ96zSRXnuH0+e68tFhfa1tjzbJHzS5oJE
	NVeBEktxRqKhFnNRcSIAI+LBhmICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the amba_pclk_enable and amba_pclk_disable macros because they
are not used by the drivers.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/amba/bus.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index fd0c0bfa1d38..275e4a346de7 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -87,12 +87,6 @@ struct amba_device *amba_find_device(const char *, struct device *, unsigned int
 int amba_request_regions(struct amba_device *, const char *);
 void amba_release_regions(struct amba_device *);
 
-#define amba_pclk_enable(d)	\
-	(IS_ERR((d)->pclk) ? 0 : clk_enable((d)->pclk))
-
-#define amba_pclk_disable(d)	\
-	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
-
 static inline void amba_pclk_prepare(struct amba_device *dev)
 {
 	clk_prepare(dev->pclk);
-- 
1.9.1

