Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087Ab3LHXy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 18:54:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36119 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab3LHXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 18:54:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/2] PCI: Don't enable realloc automatically when above 4g 64bit mmio is not supported
Date: Sun,  8 Dec 2013 15:54:27 -0800
Message-Id: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one system (Dell) realloc auto cause ixgbe does not work,
the system does not have enough range for sriov and rom.

We could try to tighten the condition about enabling realloc auto.
Not enabling realloc auto when above 64bit mmio is not there for
root bus.
So the system does not need to take "pci=realloc=off" to have working
network as old kernel.

First patch is preparing for bus address converting with bus instead of dev.

After those two patches get into pci-next or linus-tree, I will send
other patches about 64bit resource allocation.

Thanks

Yinghai

Yinghai Lu (2):
  PCI: pcibus address to resource converting take bus instead of dev
  PCI: Only enable realloc auto when root bus has 64bit mmio

 drivers/pci/host-bridge.c | 34 +++++++++++++++++++++-------------
 drivers/pci/setup-bus.c   | 32 +++++++++++++++++++++++++++-----
 include/linux/pci.h       |  5 +++++
 3 files changed, 53 insertions(+), 18 deletions(-)

-- 
1.8.4

