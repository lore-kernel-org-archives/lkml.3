Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3BDL4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:56:02 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:42457 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3BDLz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:55:59 -0500
Subject: [PATCH v2 1/7] e1000e: fix pci-device enable-counter balance
To: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 04 Feb 2013 15:55:54 +0400
Message-ID: <20130204115554.5569.95207.stgit@zurg>
In-Reply-To: <20130204115246.5569.85829.stgit@zurg>
References: <20130204115246.5569.85829.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes redundant and unbalanced pci_disable_device() from
__e1000_shutdown(). pci_clear_master() is enough, device can go into
suspended state with elevated enable_cnt.

Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: e1000-devel@lists.sourceforge.net
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index fbf75fd..49e944f 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5503,7 +5503,7 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	 */
 	e1000e_release_hw_control(adapter);
 
-	pci_disable_device(pdev);
+	pci_clear_master(pdev);
 
 	return 0;
 }

