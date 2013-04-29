Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3D2Ead (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 00:30:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab3D2Eab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 00:30:31 -0400
Date: Mon, 29 Apr 2013 06:31:45 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH -tip/apic 0/2] PCI/MSI: Allocate as many multiple-MSIs as
 requested
Message-ID: <cover.1367160713.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gentleman,

This update will allow to conserve interrupt resources when PCI
device uses multiple-MSI mode and sends lesser power-of-two MSIs.

I have held this off for some time, since there were no such usages
(at least known to me). But recently PLX Technology confirmed they
do have, i.e. their new PEX8796 chip needs 18 MSIs.

The series is against the tip/apic.

Alexander Gordeev (2):
  PCI/MSI: Allocate as many multiple-MSIs as requested
  x86/MSI: Allocate as many multiple-MSIs as requested

 drivers/iommu/irq_remapping.c |    7 ++++---
 drivers/pci/msi.c             |   10 ++++++++--
 include/linux/msi.h           |    1 +
 3 files changed, 13 insertions(+), 5 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
