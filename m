Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3JSGFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:05:08 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:10164 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750964Ab3JSGFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:05:06 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 03/29] PCI/MSI/pSeries: Fix wrong error code reporting
Date: Fri, 18 Oct 2013 19:12:03 +0200
Message-Id: <58dc22b3ed0c200581d27efd09d9e455ac0b6ea9.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/powerpc/platforms/pseries/msi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 6d2f0ab..009ec73 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -467,7 +467,7 @@ again:
 	list_for_each_entry(entry, &pdev->msi_list, list) {
 		hwirq = rtas_query_irq_number(pdn, i++);
 		if (hwirq < 0) {
-			pr_debug("rtas_msi: error (%d) getting hwirq\n", rc);
+			pr_debug("rtas_msi: error (%d) getting hwirq\n", hwirq);
 			return hwirq;
 		}
 
-- 
1.7.7.6

