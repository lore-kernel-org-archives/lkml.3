Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936605AbaFIJey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:34:54 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932801AbaFIJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 134/146] powerpc/powernv: Reset root port in firmware
Date: Mon,  9 Jun 2014 10:51:09 +0200
Message-Id: <534316178b61866cfb33416c1bfa0d64bfaae18b.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 372cf1244d7c271806b83b32b09a1c8b1b31b353 upstream.

Resetting root port has more stuff to do than that for PCIe switch
ports and we should have resetting root port done in firmware instead
of the kernel itself. The problem was introduced by commit 5b2e198e
("powerpc/powernv: Rework EEH reset").

Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/platforms/powernv/eeh-ioda.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/eeh-ioda.c b/arch/powerpc/platforms/powernv/eeh-ioda.c
index 227c7fe4067f..b91083370bc6 100644
--- a/arch/powerpc/platforms/powernv/eeh-ioda.c
+++ b/arch/powerpc/platforms/powernv/eeh-ioda.c
@@ -493,7 +493,8 @@ static int ioda_eeh_reset(struct eeh_pe *pe, int option)
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
1.9.3

