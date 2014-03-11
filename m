Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaCKRmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:42:40 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:42328 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaCKRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:42:38 -0400
Subject: [PATCH 0/5] PCI: Allocation regression fix and misc cleanups
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Mar 2014 11:42:36 -0600
Message-ID: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch (Don't check resource_size() in pci_bus_alloc_resource())
fixes a regression reported by Paul Bolle, so I intend to ask Linus to pull
it before releasing v3.14.

The others are minor cleanups with no functional change.

These are in my pci/resource branch and, except for the first one, are
intended for v3.15.

---

Bjorn Helgaas (5):
      PCI: Don't check resource_size() in pci_bus_alloc_resource()
      resources: Set type in __request_region()
      PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
      PCI: Change pci_bus_alloc_resource() type_mask to unsigned long
      PCI: Log IDE resource quirk in dmesg


 drivers/pci/bus.c   |    8 +++-----
 drivers/pci/probe.c |   16 ++++++++++++----
 include/linux/pci.h |    2 +-
 kernel/resource.c   |    4 ++--
 4 files changed, 18 insertions(+), 12 deletions(-)
