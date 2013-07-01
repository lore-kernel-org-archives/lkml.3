Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3GAUKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:10:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3GAUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>, Steve Best <sbest@us.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 19/26] powerpc/eeh: Fix fetching bus for single-dev-PE
Date: Mon,  1 Jul 2013 13:10:14 -0700
Message-Id: <20130701200732.058881668@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <shangw@linux.vnet.ibm.com>

commit ea461abf61753b4b79e625a7c20650105b990f21 upstream.

While running Linux as guest on top of phyp, we possiblly have
PE that includes single PCI device. However, we didn't return
its PCI bus correctly and it leads to failure on recovery from
EEH errors for single-dev-PE. The patch fixes the issue.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Steve Best <sbest@us.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/eeh_pe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/eeh_pe.c
+++ b/arch/powerpc/platforms/pseries/eeh_pe.c
@@ -639,7 +639,8 @@ struct pci_bus *eeh_pe_bus_get(struct ee
 
 	if (pe->type & EEH_PE_PHB) {
 		bus = pe->phb->bus;
-	} else if (pe->type & EEH_PE_BUS) {
+	} else if (pe->type & EEH_PE_BUS ||
+		   pe->type & EEH_PE_DEVICE) {
 		edev = list_first_entry(&pe->edevs, struct eeh_dev, list);
 		pdev = eeh_dev_to_pci_dev(edev);
 		if (pdev)


