Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaILSEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:04:08 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:56409 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaILSEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:04:05 -0400
Subject: [PATCH v1 11/13] PCI: Apply _HPP settings to all hot-added PCI
 devices
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:04:03 -0600
Message-ID: <20140912180403.1630.49400.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently apply _HPP settings only to:

    - non-bridge devices, and
    - PCI-to-PCI bridges

i.e., we do not apply them to PCI-to-ISA bridges and the like.  It has been
that way since _HPP support was added by 40abb96c51bb ("pciehp: Fix
programming hotplug parameters"), but I don't think there's any reason to
exclude these other bridges.

Apply _HPP settings to hot-added PCI devices of any type.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a16b3472b70d..1ff2105ba401 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1351,11 +1351,6 @@ static void pci_configure_device(struct pci_dev *dev)
 	if (system_state == SYSTEM_BOOTING)
 		return;
 
-	if (!(dev->hdr_type == PCI_HEADER_TYPE_NORMAL ||
-			(dev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
-			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
-		return;
-
 	memset(&hpp, 0, sizeof(hpp));
 	ret = pci_get_hp_params(dev, &hpp);
 	if (ret)

