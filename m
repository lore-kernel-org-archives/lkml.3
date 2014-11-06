Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKFIhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:37:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64723 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaKFIhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:37:06 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-c3-545b332f28a5
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v10 5/5] amba: Remove unused amba_pclk_enable/disable macros
Date: Thu, 06 Nov 2014 09:36:50 +0100
Message-id: <1415263010-7992-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
References: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7r6xtEhBp37+Sw2zljPajF96gVG
	i9VT/7JavH5haPF082Mmi7NNb9gtlkyez2rROXEJu8WsKXuZLC7vmsNm8bn3CKPF7cu8FmuP
	3GW3ePcywuLuqaNsFmdOX2K1mPD7ApvF8bXhFi/79rM4CHu0NPeweczumMnqsXjPSyaPTas6
	2TzuXNvD5rHkzSFWjy1X21k8Zt/9wejRt2UVo8eK1d/ZPT5vkvPY+/k3SwBPFJdNSmpOZllq
	kb5dAlfGsz2SBXfZK7p2/2dpYDzD1sXIySEhYCJx9dYjKFtM4sK99UA2F4eQwFJGiaf3f7ND
	OH1MEssvbmMGqWITMJbYvHwJWJWIwHVmie7H/SwgCWaBRUwSTVMVQWxhAR+J1esngjWwCKhK
	bL/1C8jm4OAVcJNY2iwFsU1O4uSxyawgNqeAu8SvJR+YQGwhoJL2r7PZJzDyLmBkWMUomlqa
	XFCclJ5rqFecmFtcmpeul5yfu4kREgtfdjAuPmZ1iFGAg1GJh3cDZ3SIEGtiWXFl7iFGCQ5m
	JRHeCD2gEG9KYmVValF+fFFpTmrxIUYmDk6pBka/Ty/ED8z7peefqd+y/WZIk80NV4OkSW0H
	bm157x6WN3m9Ixeb28K6WUzBERt6TS4prJh+5s07n5WtU85mq19P3ctzvM/HfNL2KSt/yK+t
	NuPbfDHav3NxyUKVTMO0h3ymjf4NS54t5ox+ZJjUw99aVFRoor7a+t3kNQvt5m+Y/CFpp2zr
	xv1KLMUZiYZazEXFiQC/DlKdYwIAAA==
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

