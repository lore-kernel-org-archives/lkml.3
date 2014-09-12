Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaILO4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:56:36 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9312 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaILO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:56:34 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d7-541309a058cf
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCH v2 0/2] amba/dma: pl330: add Power Management support
Date: Fri, 12 Sep 2014 16:56:17 +0200
Message-id: <1410533779-3310-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Zd0FnMIhBoc72S02zljPajF96gVG
	i9VT/7JaHPizg9Hi9QtDi7NNb9gtlkyez2pxedccNovbl3kt1h65y27x7mWExfG14RYv+/az
	OPB6tDT3sHks3vOSyePOtT1sHkveHGL16NuyitHj8yY5j72ff7MEsEdx2aSk5mSWpRbp2yVw
	Zey8Moet4BxHxYym64wNjB/Zuhg5OSQETCRu/D7FDGGLSVy4tx4ozsUhJLCUUWLqpIeMEE4f
	k8TsjfvZQarYBIwlNi9fAlYlInCJSeLXvdfsIA6zwFFGiem9b5lAqoQFPCUONJ1jBbFZBFQl
	puxbABbnFXCTuPC6G2qfnMTJY5NZJzByL2BkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kR
	EnJfdzAuPWZ1iFGAg1GJh/dDrmCIEGtiWXFl7iFGCQ5mJRHeG6+EQoR4UxIrq1KL8uOLSnNS
	iw8xMnFwSjUwmn6SOjjpeOvb/e/KvS/f/alVVmrPZ/ps7/PmQ6Vzbug1aere/Pr0tWbojKfB
	M6w/8Od6zed+dGWGsP8r3We2D7gftjqGs7C+8FrXkprFuCu87etCA909bxIyfITqJ0r/YLj2
	7fM8hv8THXaILXf+nKilVy++usJ885osroei8U231t7VPi5mq8RSnJFoqMVcVJwIAIEIxusX	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is second request for comments for adding runtime PM to the pl330
driver.

The runtime PM of pl330 driver requires interrupt safe suspend/resume
callbacks which is in conflict with amba bus driver. The latter
also unprepares and prepares the AMBA bus clock which is not safe
for atomic context.

The patchset solves this in patch 1/2.

Any comments are welcome.


TODO:
=====
 - Document somewhere the suspend/resume callbacks behavior between
   amba bus driver and device driver.

Changes since v1:
=================
1. Add patch 1 (amba: Allow AMBA drivers to use their own runtime PM).
2. Patch 2/2: Apply Michal Simek's suggestions.
3. Patch 2/2: Fix atomic context safeness in pl330_issue_pending().


Best regards,
Krzysztof Kozlowski

Krzysztof Kozlowski (2):
  amba: Allow AMBA drivers to use their own runtime PM
  dma: pl330: add Power Management support

 drivers/amba/bus.c  | 15 +++++++++++-
 drivers/dma/pl330.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 79 insertions(+), 5 deletions(-)

-- 
1.9.1

