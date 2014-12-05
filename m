Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaLEXpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:45:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaLEWqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.17 047/122] powerpc/powernv: Replace OPAL_DEASSERT_RESET with EEH_RESET_DEACTIVATE
Date: Fri,  5 Dec 2014 14:43:41 -0800
Message-Id: <20141205223312.635111683@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/pci-ioda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1815,7 +1815,7 @@ void __init pnv_pci_init_ioda_phb(struct
 	if (is_kdump_kernel()) {
 		pr_info("  Issue PHB reset ...\n");
 		ioda_eeh_phb_reset(hose, EEH_RESET_FUNDAMENTAL);
-		ioda_eeh_phb_reset(hose, OPAL_DEASSERT_RESET);
+		ioda_eeh_phb_reset(hose, EEH_RESET_DEACTIVATE);
 	}
 
 	/* Configure M64 window */


