Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaAaPTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:19:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409AbaAaPHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:06 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Santosh Raspatur <santosh@chelsio.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 05/34] cxgb3: Remove superfluous call to pci_disable_msix()
Date: Fri, 31 Jan 2014 16:08:24 +0100
Message-Id: <964cadfe0464e0e94886643fcf26d4f020b23e3d.1391172839.git.agordeev@redhat.com>
In-Reply-To: <cover.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call pci_disable_msix() in case
the previous call to pci_enable_msix() failed

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 45d7733..b72d2ed 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3097,9 +3097,6 @@ static int cxgb_enable_msix(struct adapter *adap)
 	while ((err = pci_enable_msix(adap->pdev, entries, vectors)) > 0)
 		vectors = err;
 
-	if (err < 0)
-		pci_disable_msix(adap->pdev);
-
 	if (!err && vectors < (adap->params.nports + 1)) {
 		pci_disable_msix(adap->pdev);
 		err = -1;
-- 
1.7.7.6

