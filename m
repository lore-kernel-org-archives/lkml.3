Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaAWU7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:59:42 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62386 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaAWU7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:59:40 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 0/8] PCI: cleanup pci_scan_bridge
Date: Thu, 23 Jan 2014 21:59:20 +0100
Message-Id: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been reading the code around pci_scan_bridge and noticed a few oddities.
These patches try to cleanup some of the these things.

Most of the patches make also sense in isolation, but some make more sense with
the previous ones applied as well. None of the patches fix any observed bugs.
Patch 5 fixes a (probably harmless) dmesg.

The changes related to CardBus probing are completely untested.

Andreas

Andreas Noever (8):
  PCI: Increment max correctly in pci_scan_bridge.
  PCI: Clarify the "scan anyway" comment in pci_scan_bridge.
  PCI: Assign CardBus bus number only during the second pass.
  PCI: Use request_resource_conflict instead of insert_ for bus numbers.
  PCI: Make sure bus number resources stay within their parents bounds.
  PCI: Remove pci_fixup_parent_subordinate_busnr.
  PCI: Check for child busses which use more bus numbers than allocated.
  PCI: Don't scan random busses in pci_scan_bridge.

 drivers/pci/probe.c | 78 +++++++++++++++++++++--------------------------------
 1 file changed, 31 insertions(+), 47 deletions(-)

-- 
1.8.5.3

