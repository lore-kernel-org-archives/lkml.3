Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaFDXxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:53:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaFDXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.14 216/228] powerpc/powernv: Reset root port in firmware
Date: Wed,  4 Jun 2014 16:24:05 -0700
Message-Id: <20140604232354.981261466@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

commit 372cf1244d7c271806b83b32b09a1c8b1b31b353 upstream.

Resetting root port has more stuff to do than that for PCIe switch
ports and we should have resetting root port done in firmware instead
of the kernel itself. The problem was introduced by commit 5b2e198e
("powerpc/powernv: Rework EEH reset").

Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/eeh-ioda.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/eeh-ioda.c
+++ b/arch/powerpc/platforms/powernv/eeh-ioda.c
@@ -549,7 +549,8 @@ static int ioda_eeh_reset(struct eeh_pe
 		ret = ioda_eeh_phb_reset(hose, option);
 	} else {
 		bus = eeh_pe_bus_get(pe);
-		if (pci_is_root_bus(bus))
+		if (pci_is_root_bus(bus) ||
+		    pci_is_root_bus(bus->parent))
 			ret = ioda_eeh_root_reset(hose, option);
 		else
 			ret = ioda_eeh_bridge_reset(hose, bus->self, option);


