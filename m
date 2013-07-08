Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3GHHXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:23:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50942 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3GHHXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:23:01 -0400
Subject: [PATCH] drivers/net: igb: release rtnl_lock on error path
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 08 Jul 2013 11:22:57 +0400
Message-ID: <20130708072257.20564.36904.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds missing rtnl_unlock()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: e1000-devel@lists.sourceforge.net
---
 drivers/net/ethernet/intel/igb/igb_main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 64cbe0d..86ac29d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7235,6 +7235,7 @@ static int igb_sriov_reinit(struct pci_dev *dev)
 	igb_init_queue_configuration(adapter);
 
 	if (igb_init_interrupt_scheme(adapter, true)) {
+		rtnl_unlock();
 		dev_err(&pdev->dev, "Unable to allocate memory for queues\n");
 		return -ENOMEM;
 	}

