Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaBJSnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:43:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34142 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaBJSm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:42:59 -0500
From: Colin King <colin.king@canonical.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David.Daney@caviumnetworks.com
Subject: [PATCH] MIPS: Octeon: fix fall through on bar type OCTEON_DMA_BAR_TYPE_SMALL
Date: Mon, 10 Feb 2014 18:42:57 +0000
Message-Id: <1392057777-14919-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Bar type OCTEON_DMA_BAR_TYPE_SMALL assigns lo and hi addresses and
then falls through to OCTEON_DMA_BAR_TYPE_BIG that re-assignes lo and
hi addresses with totally different values. Add a break so we don't
fall through.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/pci/msi-octeon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/pci/msi-octeon.c b/arch/mips/pci/msi-octeon.c
index d37be36..2b91b0e 100644
--- a/arch/mips/pci/msi-octeon.c
+++ b/arch/mips/pci/msi-octeon.c
@@ -150,6 +150,7 @@ msi_irq_allocated:
 		msg.address_lo =
 			((128ul << 20) + CVMX_PCI_MSI_RCV) & 0xffffffff;
 		msg.address_hi = ((128ul << 20) + CVMX_PCI_MSI_RCV) >> 32;
+		break;
 	case OCTEON_DMA_BAR_TYPE_BIG:
 		/* When using big bar, Bar 0 is based at 0 */
 		msg.address_lo = (0 + CVMX_PCI_MSI_RCV) & 0xffffffff;
-- 
1.9.rc1

