Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaAGQE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:04:29 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38387
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbaAGQEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:04:22 -0500
X-IronPort-AV: E=Sophos;i="4.95,619,1384297200"; 
   d="scan'208";a="43870452"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: kernel-janitors@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ixgbevf: delete unneeded call to pci_set_power_state
Date: Tue,  7 Jan 2014 18:00:26 +0100
Message-Id: <1389114026-27854-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

This driver does not need to adjust the power state on suspend, so the
call to pci_set_power_state in the resume function is a no-op.  Drop it, to
make the code more understandable.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index a5d3167..5709fb0 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -3226,7 +3226,6 @@ static int ixgbevf_resume(struct pci_dev *pdev)
 	struct net_device *netdev = adapter->netdev;
 	u32 err;
 
-	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 	/*
 	 * pci_restore_state clears dev->state_saved so call

