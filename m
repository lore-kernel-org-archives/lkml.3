Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3BEWHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:07:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47827 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab3BEWHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:07:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Betty Dall <betty.dall@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 04/93] PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_put()
Date: Tue,  5 Feb 2013 20:05:53 -0200
Message-Id: <1360102042-10732-5-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Betty Dall <betty.dall@hp.com>

commit a82b6af37d20bfe6e99a4d890f1cf1d89059929f upstream.

The function aer_recover_queue() calls pci_get_domain_bus_and_slot(), which
requires that the caller decrement the reference count with pci_dev_put().
This patch adds the missing call to pci_dev_put().

Signed-off-by: Betty Dall <betty.dall@hp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pci/pcie/aer/aerdrv_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 0ca0535..a56105b 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -637,6 +637,7 @@ static void aer_recover_work_func(struct work_struct *work)
 			continue;
 		}
 		do_recovery(pdev, entry.severity);
+		pci_dev_put(pdev);
 	}
 }
 #endif
-- 
1.7.9.5

