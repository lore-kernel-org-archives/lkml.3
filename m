Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaFCMFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:05:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43547 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbaFCLlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 067/138] powerpc/powernv: Reset root port in firmware
Date: Tue,  3 Jun 2014 12:38:33 +0100
Message-Id: <1401795584-22664-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

commit 372cf1244d7c271806b83b32b09a1c8b1b31b353 upstream.

Resetting root port has more stuff to do than that for PCIe switch
ports and we should have resetting root port done in firmware instead
of the kernel itself. The problem was introduced by commit 5b2e198e
("powerpc/powernv: Rework EEH reset").

Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/powernv/eeh-ioda.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/eeh-ioda.c b/arch/powerpc/platforms/powernv/eeh-ioda.c
index d972157b1e17..3dfcfa164ebb 100644
--- a/arch/powerpc/platforms/powernv/eeh-ioda.c
+++ b/arch/powerpc/platforms/powernv/eeh-ioda.c
@@ -500,7 +500,8 @@ static int ioda_eeh_reset(struct eeh_pe *pe, int option)
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

