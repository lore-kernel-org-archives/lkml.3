Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3AUUSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:18:44 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:23244
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab3AUUSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:18:43 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
X-WSS-ID: 0MGZSEY-01-3BA-02
X-M-MSG: 
From: "Steven L. Kinney" <steven.kinney@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Steven L. Kinney" <steven.kinney@amd.com>
Subject: [PATCH 0/3] AMD IOMMUv2 Performance Counter patches
Date: Mon, 21 Jan 2013 14:18:00 -0600
Message-ID: <1358799483-6198-1-git-send-email-steven.kinney@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven L. Kinney" <steven.kinney@amd.com>

These patches implement the AMD IOMMUv2.5 Performance Counter functionality
via custom perf PMU and implement static counting for various IOMMU
translations.  The patches address three areas of functionality:

1) 	Add a PCI quirk for the enablement of IOMMUv2 EFR PC within a specific
	AMD family/model in which BIOS has not enabled.  Based on code 
	implemented by Andreas Herrmann at AMD Dresden.
2)	Extend the AMD IOMMU initialization to include IOMMUv2 PC enablement
	and access to IOMMUv2 counter registers.  For all AMD family/models
	that implement IOMMUv2.5 functionality.
3)	Code the perf IOMMUv2 PMU to manage IOMMUv2 perf events, which call
	the function(s) extending the AMD IOMMU core driver.  For all AMD
	family/models that implement IOMMUv2.5 functionality.

The command-line, to invoke the iommuv2 PMU, is:

perf stat -e iommuv2/config=[data],config1=[data]/{u,r} [command]

For information regarding AMD IOMMU v2.5 PC configuration, see the public
specification.

Steven L. Kinney (3):
  AMD x86 quirks: Quirk for enabling IOMMUv2 PC feature
  AMD IOMMUv2 PC resource management hooks
  AMD IOMMUv2 PC perf PMU implementation

 arch/x86/kernel/cpu/Makefile                 |    1 +
 arch/x86/kernel/cpu/perf_event_amd_iommuv2.c |  429 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd_iommuv2.h |   42 +++
 arch/x86/kernel/quirks.c                     |   17 +
 drivers/iommu/Kconfig                        |   10 +
 drivers/iommu/amd_iommu_init.c               |   99 ++++++
 drivers/iommu/amd_iommu_types.h              |   12 +
 include/linux/pci_ids.h                      |    2 +
 8 files changed, 612 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommuv2.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommuv2.h

-- 
1.7.9.5


