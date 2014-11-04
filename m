Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaKDMxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:53:45 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46565 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbaKDMxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:53:13 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-dd-5458cc322e75
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
Subject: [PATCH v9 4/4] amba: Remove unused amba_pclk_enable/disable macros
Date: Tue, 04 Nov 2014 13:52:50 +0100
Message-id: <1415105570-7871-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xq7pGZyJCDL7/5LbYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF6xeGFk83P2ayONv0ht1iyeT5rBadE5ewW8yaspfJ4vKuOWwWn3uPMFrc
	vsxrsfbIXXaLdy8jLO6eOspmceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+yOmawei/e8
	ZPLYtKqTzePOtT1sHov7JrN6LHlziNVjy9V2Fo/Zd38wevRtWcXosWL1d3aPz5vkPPZ+/s0S
	wBvFZZOSmpNZllqkb5fAlfFsj2TBXfaKrt3/WRoYz7B1MXJySAiYSLQ1/ISyxSQu3FsPZHNx
	CAksZZT4ubuFCcLpY5K48XAPI0gVm4CxxOblS8CqRARWsUi82nMdzGEW+MgocXP1RmaQKmEB
	b4mO2QfBOlgEVCV+zV8HtoNXwE3i/NtWdoh9chInj01mBbE5Bdwltm7cB1YjBFTz5tEbtgmM
	vAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihMTI1x2MS49ZHWIU4GBU4uFdER8RIsSa
	WFZcmXuIUYKDWUmEd9tpoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGrowL7x+wx5ZZSnvr6PNx
	dN4z2bS8vDTw0u9NXXc2qN5NKM4LaJafqL2j7d153jteqR0VLxY3HTu4SWiHzZWLbmJzeTel
	35m4JF6kV3wV7/6OG4IRq06fdWGIDPt9bpdjdNiOuVweq3wmFOpEsml4XZySFTtzd9KP1o19
	316x3Ltyf2bs6noeJZbijERDLeai4kQAibBeIG8CAAA=
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

