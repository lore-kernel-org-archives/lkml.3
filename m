Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaBRKHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:07:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbaBRKGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:06:49 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Casey Leedom <leedom@chelsio.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH net-next 08/35] cxgb4vf: Remove superfluous call to pci_disable_msix()
Date: Tue, 18 Feb 2014 11:08:00 +0100
Message-Id: <88e8e62d2dd643c9237c9cdb86fe19444f3651b8.1392717503.git.agordeev@redhat.com>
In-Reply-To: <cover.1392717502.git.agordeev@redhat.com>
References: <cover.1392717502.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call pci_disable_msix() in case
the previous call to pci_enable_msix() failed

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Casey Leedom <leedom@chelsio.com>
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 0899c09..509fed9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2475,7 +2475,6 @@ static int enable_msix(struct adapter *adapter)
 		for (i = 0; i < want; ++i)
 			adapter->msix_info[i].vec = entries[i].vector;
 	} else if (err > 0) {
-		pci_disable_msix(adapter->pdev);
 		dev_info(adapter->pdev_dev, "only %d MSI-X vectors left,"
 			 " not using MSI-X\n", err);
 	}
-- 
1.7.7.6

