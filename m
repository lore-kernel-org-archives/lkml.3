Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaHTL7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:59:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58974 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Ertman <davidx.m.ertman@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 071/104] e1000e: Fix a compile flag mis-match for suspend/resume
Date: Wed, 20 Aug 2014 13:43:34 +0200
Message-Id: <fd1a37d68313776ef0ff5d2e8aa74fb9d568eafd.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ertman <davidx.m.ertman@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7509963c703b71eebccc421585e7f48ebbbd3f38 upstream.

This patch addresses a mis-match between the declaration and usage of
the e1000_suspend and e1000_resume functions.  Previously, these
functions were declared in a CONFIG_PM_SLEEP wrapper, and then utilized
within a CONFIG_PM wrapper.  Both the declaration and usage will now be
contained within CONFIG_PM wrappers.

Signed-off-by: Dave Ertman <davidx.m.ertman@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 959bdd630809..2778858957f6 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6186,7 +6186,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 static int e1000_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -6205,7 +6205,7 @@ static int e1000_resume(struct device *dev)
 
 	return __e1000_resume(pdev);
 }
-#endif /* CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_RUNTIME
 static int e1000_runtime_suspend(struct device *dev)
-- 
2.0.4

