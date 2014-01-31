Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaAaPHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:07:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbaAaPHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:12 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Casey Leedom <leedom@chelsio.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 08/34] cxgb4vf: Remove superfluous call to pci_disable_msix()
Date: Fri, 31 Jan 2014 16:08:27 +0100
Message-Id: <b33d0be122a433109d0fa1ec7604ed021dcae08c.1391172839.git.agordeev@redhat.com>
In-Reply-To: <cover.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call pci_disable_msix() in case
the previous call to pci_enable_msix() failed

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
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

