Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaAWVC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:02:28 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64449 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaAWVAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:00:01 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 2/8] PCI: Clarify the "scan anyway" comment in pci_scan_bridge.
Date: Thu, 23 Jan 2014 21:59:22 +0100
Message-Id: <1390510768-5652-3-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
References: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initially when we encountered a bus that was already present we skipped
it. Since 74710ded8e16 'PCI: always scan child buses' we continue
scanning in order to allow user triggered rescans of already existing
busses.

The old comment suggested that the reason for continuing the scan is a
bug in the i450NX chipset. This is not the case.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/probe.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 78caade..cf05b3e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -805,11 +805,10 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 			goto out;
 
 		/*
-		 * If we already got to this bus through a different bridge,
-		 * don't re-add it. This can happen with the i450NX chipset.
-		 *
-		 * However, we continue to descend down the hierarchy and
-		 * scan remaining child buses.
+		 * The bus might already exist for two reasons: Either we are
+		 * rescanning the bus or the bus is reachable through more than
+		 * one bridge. The second case can happen with the i450NX
+		 * chipset.
 		 */
 		child = pci_find_bus(pci_domain_nr(bus), secondary);
 		if (!child) {
-- 
1.8.5.3

