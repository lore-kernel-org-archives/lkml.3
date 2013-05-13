Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3EMVmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:42:52 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:24351
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092Ab3EMVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:42:51 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah172d07h8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MMRAZ9-01-067-02
X-M-MSG: 
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>,
        <joro@8bytes.org>
CC: <steven.kinney@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/2 v2] perf/x86/amd: IOMMU Performance Counter Support
Date: Mon, 13 May 2013 16:42:42 -0500
Message-ID: <1368481362-5562-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the rework of the original patch set here:

http://lists.linuxfoundation.org/pipermail/iommu/2013-January/005075.html

These patches implement the AMD IOMMU Performance Counter functionality
via custom perf PMU and implement static counting for various IOMMU
translations.

    1) Extend the AMD IOMMU initialization to include performance
       counter enablement.

    2) The perf AMD IOMMU PMU to manage performance counters, which
       interface with the AMD IOMMU core driver.

The command-line, to invoke the iommuv2 PMU, is:

    perf stat -e amd_iommu/config=[data],config1=[data]/{u,r} [command]

The IOMMU performance counter support is available starting in the 
AMD family15h model 0x30.

For information regarding IOMMU performance counter configuration,
please see the AMD IOMMU v2.5 specification.

Steven L Kinney (2):
  IOMMU/AMD: Adding IOMMUv2 PC resource management
  IOMMU/AMD: IOMMUV2 PC PERF uncore PMU implementation

 arch/x86/kernel/cpu/Makefile                 |    2 +-
 arch/x86/kernel/cpu/perf_event_amd_iommuv2.c |  409 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd_iommuv2.h |   55 ++++
 drivers/iommu/amd_iommu_init.c               |  116 +++++++-
 drivers/iommu/amd_iommu_proto.h              |    7 +
 drivers/iommu/amd_iommu_types.h              |   12 +-
 6 files changed, 594 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommuv2.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommuv2.h

-- 
1.7.10.4


