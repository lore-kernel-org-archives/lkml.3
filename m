Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaLOOov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:44:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaLOO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 115/168] powerpc/powernv: Replace OPAL_DEASSERT_RESET with EEH_RESET_DEACTIVATE
Date: Mon, 15 Dec 2014 14:26:09 +0000
Message-Id: <1418653622-21105-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

commit 360d88a9e3fba596a12520b242fbab1c45b983e1 upstream.

The flag passed to ioda_eeh_phb_reset() should be EEH_RESET_DEACTIVATE,
which is translated to OPAL_DEASSERT_RESET or something else by the
EEH backend accordingly.

The patch replaces OPAL_DEASSERT_RESET with EEH_RESET_DEACTIVATE for
ioda_eeh_phb_reset().

Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index dc30aa5a2ce8..c339a2fbdf0b 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1403,7 +1403,7 @@ void __init pnv_pci_init_ioda_phb(struct device_node *np,
 	if (is_kdump_kernel()) {
 		pr_info("  Issue PHB reset ...\n");
 		ioda_eeh_phb_reset(hose, EEH_RESET_FUNDAMENTAL);
-		ioda_eeh_phb_reset(hose, OPAL_DEASSERT_RESET);
+		ioda_eeh_phb_reset(hose, EEH_RESET_DEACTIVATE);
 	}
 }
 
-- 
2.1.3

