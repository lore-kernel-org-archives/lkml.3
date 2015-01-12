Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbbALTXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:23:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47531 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbbALTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:23:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/10] PCI: clip firmware assigned resources
Date: Mon, 12 Jan 2015 11:23:10 -0800
Message-Id: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the fix https://bugzilla.kernel.org/show_bug.cgi?id=85491,
Bjorn suggest that we should clip the resources instead of just
reject them.

We should only need first two for x86. others for related arches
to keep them consistent.

Thanks

Yinghai


Yinghai Lu (10):
  PCI: clip firmware assigned resource under parent bridge's
  PCI, x86: clip firmware assigned resource under parent bridge's
  PCI, alpha: clip firmware assigned resource under parent bridge's
  PCI, frv: clip firmware assigned resource under parent bridge's
  PCI, ia64: clip firmware assigned resource under parent bridge's
  PCI, microblaze: clip firmware assigned resource under parent bridge's
  PCI, mn10300: clip firmware assigned resource under parent bridge's
  PCI, parisc: clip firmware assigned resource under parent bridge's
  PCI, powerpc: clip firmware assigned resource under parent bridge's
  PCI, sparc: clip firmware assigned resource under parent bridge's

 arch/alpha/kernel/pci.c                 | 24 ++++++++++-
 arch/frv/mb93090-mb00/pci-frv.c         | 33 ++++++++++++---
 arch/ia64/pci/pci.c                     | 71 +++++++++++++++++++------------
 arch/microblaze/pci/pci-common.c        | 42 ++++++++++++++++++-
 arch/mn10300/unit-asb2305/pci-asb2305.c | 61 ++++++++++++++++++---------
 arch/mn10300/unit-asb2305/pci.c         | 69 ++++++++++++++++++------------
 arch/powerpc/kernel/pci-common.c        | 43 ++++++++++++++++++-
 arch/sparc/kernel/pci.c                 | 20 ++++++++-
 arch/x86/pci/i386.c                     | 74 +++++++++++++++++++++++----------
 drivers/parisc/lba_pci.c                | 26 +++++++++++-
 drivers/pci/bus.c                       | 37 +++++++++++++++++
 include/linux/pci.h                     |  1 +
 12 files changed, 394 insertions(+), 107 deletions(-)

-- 
1.8.4.5

