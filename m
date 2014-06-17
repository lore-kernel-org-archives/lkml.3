Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966284AbaFQVsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965396AbaFQVss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 107/212] powerpc/powernv: Reset root port in firmware
Date: Tue, 17 Jun 2014 14:43:21 -0700
Message-Id: <1403041506-13646-108-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

commit 372cf1244d7c271806b83b32b09a1c8b1b31b353 upstream.

Resetting root port has more stuff to do than that for PCIe switch
ports and we should have resetting root port done in firmware instead
of the kernel itself. The problem was introduced by commit 5b2e198e
("powerpc/powernv: Rework EEH reset").

Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/platforms/powernv/eeh-ioda.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/eeh-ioda.c b/arch/powerpc/platforms/powernv/eeh-ioda.c
index 27e5f02..aba71c3 100644
--- a/arch/powerpc/platforms/powernv/eeh-ioda.c
+++ b/arch/powerpc/platforms/powernv/eeh-ioda.c
@@ -549,7 +549,8 @@ static int ioda_eeh_reset(struct eeh_pe *pe, int option)
 		ret = ioda_eeh_phb_reset(hose, option);
 	} else {
 		bus = eeh_pe_bus_get(pe);
-		if (pci_is_root_bus(bus))
+		if (pci_is_root_bus(bus) ||
+		    pci_is_root_bus(bus->parent))
 			ret = ioda_eeh_root_reset(hose, option);
 		else
 			ret = ioda_eeh_bridge_reset(hose, bus->self, option);
-- 
1.9.1

