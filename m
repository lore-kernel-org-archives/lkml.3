Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaHRQMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:12:36 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:59776 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHRQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:12:34 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 0/4] Allow xHCI drivers to be built as separate modules
Date: Mon, 18 Aug 2014 09:12:19 -0700
Message-Id: <1408378343-9352-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was suggested in the review of the Tegra xHCI driver [1] that we
allow xHCI drivers to be built as individual modules (like EHCI) instead
of building them all into the single xhci-hcd module as they are today.

Patches 1-3 prepare for making the xHCI PCI and platform drivers able
to be built as individual modules and patch 4 actually creates the 3
separate modules (core, platform, PCI).

Based on 3.17-rc1.

Changes from v1:
 - rebased on changes introduced by xhci-rcar driver

[1] http://patchwork.ozlabs.org/patch/361265/

Andrew Bresticker (4):
  xhci: Introduce xhci_init_driver()
  xhci: Check for XHCI_COMP_MODE_QUIRK when disabling D3cold
  xhci: Export symbols used by host-controller drivers
  xhci: Allow xHCI drivers to be built as separate modules

 drivers/usb/host/Kconfig     |  5 +++
 drivers/usb/host/Makefile    | 12 +++---
 drivers/usb/host/xhci-dbg.c  |  1 +
 drivers/usb/host/xhci-pci.c  | 80 +++++++-----------------------------
 drivers/usb/host/xhci-plat.c | 68 ++++++-------------------------
 drivers/usb/host/xhci.c      | 97 +++++++++++++++++++++++++++++++++-----------
 drivers/usb/host/xhci.h      | 23 +----------
 7 files changed, 114 insertions(+), 172 deletions(-)

-- 
2.1.0.rc2.206.gedb03e5

