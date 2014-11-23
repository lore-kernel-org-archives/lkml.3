Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaKWTDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:03:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:34954 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaKWTDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:03:43 -0500
Date: Sun, 23 Nov 2014 20:03:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Ingo Molnar <mingo@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>
Subject: Hierarchical irqdomains - Status update
Message-ID: <alpine.DEB.2.11.1411231915010.6439@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I've rebased the hierarchical irqdomain code on top of Bjorns
msi_controller rework.

Changes versus the previous version:

   - Bjorns new pci/mci branch. See also:
        http://lkml.kernel.org/r/20141121172018.GA6578@google.com

     Thanks Bjorn for fixing that just before your vacation!

   - Rename of msi_mask/unmask_irq et al so it's clear that these
     functions are PCI related and cannot be used for non PCI based
     MSI functionality.

   - Folded back fixup patches

   - Added the missing parent check as reported by Suravee

The branch is now immutable and you can base your patches on it.

If you need to pull the branch into your tree, please let me know.

Patches which are mostly touching drivers/irqchip should go through
Jason. Please post them against irq/irqdomain. We'll either create a
seperate branch for them or merge irq/irqdomain into irq/core.

Thanks for the fruitful discussions, testing, rebasing and patience.

Thanks,

	tglx
