Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbbAOEb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:31:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21385 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbAOEby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:31:54 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 00/10] PCI: clip firmware assigned resources
Date: Wed, 14 Jan 2015 20:31:27 -0800
Message-Id: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the fix https://bugzilla.kernel.org/show_bug.cgi?id=85491,
Bjorn suggest that we should clip the resources instead of just
reject them.

We should only need first two for x86. others for related arches
to keep them consistent.

-v2: only handle bridge resource, and add pci_claim_bridge_resource
	in pci core code.

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

 arch/alpha/kernel/pci.c                 |  8 +++--
 arch/frv/mb93090-mb00/pci-frv.c         |  2 +-
 arch/ia64/pci/pci.c                     | 48 +++++++++++++---------------
 arch/microblaze/pci/pci-common.c        | 13 +++++++-
 arch/mn10300/unit-asb2305/pci-asb2305.c |  2 +-
 arch/mn10300/unit-asb2305/pci.c         | 47 +++++++++++++--------------
 arch/powerpc/kernel/pci-common.c        | 12 ++++++-
 arch/sparc/kernel/pci.c                 |  5 ++-
 arch/x86/pci/i386.c                     |  2 +-
 drivers/parisc/lba_pci.c                |  5 ++-
 drivers/pci/bus.c                       | 39 +++++++++++++++++++++++
 drivers/pci/pci.h                       |  1 +
 drivers/pci/setup-bus.c                 | 56 ++++++++++++++++++++++++++-------
 include/linux/pci.h                     |  1 +
 14 files changed, 165 insertions(+), 76 deletions(-)

-- 
1.8.4.5

