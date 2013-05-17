Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3EQTsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:48:52 -0400
Received: from [207.46.163.28] ([207.46.163.28]:22187 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756631Ab3EQTsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:48:50 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MMYK8M-01-D2V-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>,
        <joro@8bytes.org>
CC: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/2 V3] perf/x86/amd: IOMMU Performance Counter Support
Date: Fri, 17 May 2013 14:43:30 -0500
Message-ID: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

These patches implement the AMD IOMMU Performance Counter functionality
via custom perf PMU and implement static counting for various IOMMU
translations.

    1) Extend the AMD IOMMU initialization to include performance
       counter enablement.

    2) The perf AMD IOMMU PMU to manage performance counters, which
       interface with the AMD IOMMU core driver.

Steven L Kinney (1):
  perf/x86/amd: Adding IOMMU PC resource management

Suravee Suthikulpanit (1):
  perf/x86/amd: AMD IOMMU PC PERF uncore PMU implementation

 arch/x86/kernel/cpu/Makefile               |    2 +-
 arch/x86/kernel/cpu/perf_event_amd_iommu.c |  500 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd_iommu.h |   40 +++
 drivers/iommu/amd_iommu_init.c             |  121 ++++++-
 drivers/iommu/amd_iommu_proto.h            |    7 +
 drivers/iommu/amd_iommu_types.h            |   12 +-
 6 files changed, 675 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.h

-- 
1.7.10.4


