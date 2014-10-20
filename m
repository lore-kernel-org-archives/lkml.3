Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaJTJFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:05:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43755 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaJTJF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:05:27 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-5f-5444d052d222
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v8 5/5] amba: Remove unused amba_pclk_enable/disable macros
Date: Mon, 20 Oct 2014 11:04:48 +0200
Message-id: <1413795888-18559-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xa7pBF1xCDHacNLbYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLM6cvsRqMeH3BTaL42vDLV727WdxEPZoae5h81i85yWTx51re4Csvsms
	HkveHGL12HK1ncVj9t0fjB59W1YxeqxY/Z3d4/MmOY+9n3+zBHBHcdmkpOZklqUW6dslcGU8
	2yNZcJe9omv3f5YGxjNsXYycHBICJhI3Gm8wQthiEhfurQeLCwksZZTY3ibcxcgFZPcxScz/
	9JoFJMEmYCyxefkSNpCEiMBxFonFPRfAHGaBKYwSzZOWMoFUCQt4S1w80gc2lkVAVeL67btg
	3bwC7hLvdi2DWi0ncfLYZFYQm1PAQ2J6y2NGiNXuEt0LVzFNYORdwMiwilE0tTS5oDgpPddI
	rzgxt7g0L10vOT93EyMkBr7uYFx6zOoQowAHoxIP7w4zlxAh1sSy4srcQ4wSHMxKIrxMR4FC
	vCmJlVWpRfnxRaU5qcWHGJk4OKUaGNMbvW/8m7bY8+OdWX9UZsjeL+81nnHfYFZFusgSOVfX
	6868qZv1FLjFDe5OLxT7sTC5/ILGl1cLLvrXu1v+qsn+26Aw78s0pXxRsXXzesOXJYbc6C68
	ccPY7n3wgZLlSy/13N9soVHwOfue63/WfRbzG1YzhKTP0FynJVmbsNVjTU71ybRdOUosxRmJ
	hlrMRcWJAGog6oBfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the amba_pclk_enable and amba_pclk_disable macros because they
are not used by the drivers.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 include/linux/amba/bus.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index c4bae79851fb..566adf0e0412 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -92,12 +92,6 @@ struct amba_device *amba_find_device(const char *, struct device *, unsigned int
 int amba_request_regions(struct amba_device *, const char *);
 void amba_release_regions(struct amba_device *);
 
-#define amba_pclk_enable(d)	\
-	(IS_ERR((d)->pclk) ? 0 : clk_enable((d)->pclk))
-
-#define amba_pclk_disable(d)	\
-	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
-
 static inline int amba_pclk_prepare(struct amba_device *dev)
 {
 	return clk_prepare(dev->pclk);
-- 
1.9.1

