Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3BDLz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:55:58 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:63861 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab3BDLzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:55:55 -0500
Subject: [PATCH v2 0/7] pci/e1000e: return runtime-pm back to work
To: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Mon, 04 Feb 2013 15:55:47 +0400
Message-ID: <20130204115246.5569.85829.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains some fixes for e1000e diver (broken since v2.6.35)
and some related fixes and useful debug for PCI code.

All together this fixes my regression report for v3.8-rc1:
https://lkml.org/lkml/2013/1/1/25

patchset was seriously reworked since v1:
http://lkml.org/lkml/2013/1/18/147

---

Konstantin Khlebnikov (6):
      e1000e: fix pci-device enable-counter balance
      PCI: don't touch enable_cnt in pci_device_shutdown()
      PCI: catch enable-counter underflows
      e1000e: fix runtime power management transitions
      PCI/PM: warn about incomplete actions in ->runtime_suspend() callback
      e1000e: fix accessing to suspended device

Rafael J. Wysocki (1):
      PCI/PM: clear state_saved during suspend


 drivers/net/ethernet/intel/e1000e/ethtool.c |   13 ++++
 drivers/net/ethernet/intel/e1000e/netdev.c  |   82 +++++++--------------------
 drivers/pci/pci-driver.c                    |   21 +++++--
 drivers/pci/pci.c                           |    3 +
 4 files changed, 53 insertions(+), 66 deletions(-)

-- 
Signature
