Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3C0Xuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:50:50 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:58569
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645Ab3C0Xut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:50:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCFKJ-01-64O-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/3] iommu/amd: Improve IOMMU Event Log Interrupt Handling
Date: Wed, 27 Mar 2013 18:50:15 -0500
Message-ID: <1364428215-2513-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Typically, IOMMU events are logged into the event log.  Current driver processes each event
in the log when the hardware generate an MSI interrupt. It reports event type, device ID, 
raw status flag, and etc. in the kernel log (dmesg)

1. The first patch improve event reporting by using the type of event and status flag to 
decode event information and provide more detail in the report. This should also be useful 
when debugging IOMMU issues.

2. The second patch provide interface for testing the event decoding logic using the debugfs.

3. Fix IOMMU event log interrupt handling which currently does not re-enable the event interrupt.

 drivers/iommu/Kconfig            |    9 ++
 drivers/iommu/Makefile           |    1 +
 drivers/iommu/amd_iommu.c        |  167 ++++++++++++++++++++++++++++++++------
 drivers/iommu/amd_iommu_inject.c |   99 ++++++++++++++++++++++
 drivers/iommu/amd_iommu_proto.h  |    9 ++
 drivers/iommu/amd_iommu_types.h  |    1 +
 6 files changed, 259 insertions(+), 27 deletions(-)
 create mode 100644 drivers/iommu/amd_iommu_inject.c

-- 
1.7.10.4


