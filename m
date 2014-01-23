Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaAWVB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:01:58 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:36635 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbaAWVAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:00:02 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 3/8] PCI: Assign CardBus bus number only during the second pass.
Date: Thu, 23 Jan 2014 21:59:23 +0100
Message-Id: <1390510768-5652-4-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
References: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now the CardBus code in pci_scan_bridge is executed during both
passes. Since we always allocate the bus number ourselves it makes sense
to put it into the second pass.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cf05b3e..bed1934 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -831,7 +831,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 		 * do in the second pass.
 		 */
 		if (!pass) {
-			if (pcibios_assign_all_busses() || broken)
+			if (pcibios_assign_all_busses() || broken || is_cardbus)
 				/* Temporarily disable forwarding of the
 				   configuration cycles on all bridges in
 				   this bus segment to avoid possible
-- 
1.8.5.3

