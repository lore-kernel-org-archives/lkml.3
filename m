Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaD1TvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:51:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:34902 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbaD1Tu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:50:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,945,1389772800"; 
   d="scan'208";a="502476291"
Subject: [PATCH] goldfish bus: don't call request_mem_region
To: greg@kroah.com, linux-kernel@vger.kernel.org
From: Alan Cox <alan@linux.intel.com>
Date: Mon, 28 Apr 2014 20:50:56 +0100
Message-ID: <20140428195018.23897.1644.stgit@acox1-desk.ger.corp.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a bug fix that has been lurking in the Google tree but not pushed
upstream.

From: Octavian Purdila <octavian.purdila@intel.com>

The memory region is already reserved in goldfish_init() during
platform init.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Signed-off-by: Jun Tian <jun.j.tian@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/platform/goldfish/pdev_bus.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/platform/goldfish/pdev_bus.c b/drivers/platform/goldfish/pdev_bus.c
index 92cc4cf..4eb2bb3 100644
--- a/drivers/platform/goldfish/pdev_bus.c
+++ b/drivers/platform/goldfish/pdev_bus.c
@@ -184,11 +184,6 @@ static int goldfish_pdev_bus_probe(struct platform_device *pdev)
 	pdev_bus_addr = r->start;
 	pdev_bus_len = resource_size(r);
 
-	if (request_mem_region(pdev_bus_addr, pdev_bus_len, "goldfish")) {
-		dev_err(&pdev->dev, "unable to reserve Goldfish MMIO.\n");
-		return -EBUSY;
-	}
-
 	pdev_bus_base = ioremap(pdev_bus_addr, pdev_bus_len);
 	if (pdev_bus_base == NULL) {
 		ret = -ENOMEM;

