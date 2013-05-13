Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab3EMJEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:04:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab3EMJED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:04:03 -0400
Date: Mon, 13 May 2013 11:05:20 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v3 -tip x86/apic 0/2] PCI/MSI: Allocate as many multiple-MSIs
 as requested
Message-ID: <cover.1368431413.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is against tip's x86/apic branch.

Allow conserving interrupt resources when PCI devices in multiple-MSI
mode send a number of MSIs which is not a power-of-two. This update
will prevent wasting of any resources associated with unused MSIs in
general (i.e. IRQ descriptors) and x86 interrupt vectors in particular
(the latter are notoriously scarce).

Recently PLX Technology confirmed they do have a relevant hardware,
i.e. their new PEX8796 chip can send 18 MSIs.


Changes from v2:
	- patch 2/2 changelog message elaborated

Changes from v1:
	- do not conserve on IRTEs to prevent possible security
	  hole when one device accesses other device's IRTEs


Patch 1 is a change to the generic MSI code
Patch 2 is the x86 enablement

Alexander Gordeev (2):
  PCI/MSI: Allocate as many multiple-MSIs as requested
  x86/MSI: Conserve interrupt resources when using multiple-MSIs

 drivers/iommu/irq_remapping.c |   12 +++++++-----
 drivers/pci/msi.c             |   10 ++++++++--
 include/linux/msi.h           |    1 +
 3 files changed, 16 insertions(+), 7 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
