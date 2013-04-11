Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161578Ab3DKP1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:27:14 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:47899 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936405Ab3DKP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:27:08 -0400
From: Andrew Murray <Andrew.Murray@arm.com>
To: rob.herring@calxeda.com
Cc: jgunthorpe@obsidianresearch.com, linux@arm.linux.org.uk,
        siva.kallam@samsung.com, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, jg1.han@samsung.com,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        bhelgaas@google.com, suren.reddy@samsung.com,
        linux-arm-kernel@lists.infradead.org, monstr@monstr.eu,
        benh@kernel.crashing.org, paulus@samba.org, grant.likely@secretlab.ca,
        thomas.petazzoni@free-electrons.com, thierry.reding@avionic-design.de,
        thomas.abraham@linaro.org, arnd@arndb.de, linus.walleij@linaro.org,
        Andrew Murray <Andrew.Murray@arm.com>
Subject: [PATCH v6 0/3] of/pci: Provide common support for PCI DT parsing
Date: Thu, 11 Apr 2013 16:26:06 +0100
Message-Id: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset factors out duplicated code associated with parsing PCI
DT "ranges" properties across the architectures and introduces a
"ranges" parser. This parser "of_pci_range_parser" can be used directly
by ARM host bridge drivers enabling them to obtain ranges from device
trees.

I've included the Reviewed-by and Tested-by's received from v5 in this
patchset, earlier versions of this patchset (v3) have been tested-by:

Thierry Reding <thierry.reding@avionic-design.de>
Jingoo Han <jg1.han@samsung.com>

I believe a version of this patchset has also been tested through its
inclusion in Thomas Petazzoni's Armada 370 and Armada XP SoCs PCIe support by:

Linus Walleij <linus.walleij@linaro.org>

I've tested that this patchset builds and runs on ARM and that it builds on
PowerPC.

Compared to the v5 sent by Andrew Murray, the following changes have
been made:

 * Use of CONFIG_64BIT instead of CONFIG_[a32bitarch] as suggested by
   Rob Herring in drivers/of/of_pci.c

 * Added forward declaration of struct pci_controller in linux/of_pci.h
   to prevent compiler warning as suggested by Thomas Petazzoni

 * Improved error checking (!range check), removal of unnecessary be32_to_cpup
   call, improved formatting of struct of_pci_range_parser layout and
   replacement of macro with a static inline. All suggested by Rob Herring.

Compared to the v4 (incorrectly labelled v3) sent by Andrew Murray,
the following changes have been made:

 * Split the patch as suggested by Rob Herring

Compared to the v3 sent by Andrew Murray, the following changes have
been made:

 * Unify and move duplicate pci_process_bridge_OF_ranges functions to
   drivers/of/of_pci.c as suggested by Rob Herring

 * Fix potential build errors with Microblaze/MIPS

Compared to "[PATCH v5 01/17] of/pci: Provide support for parsing PCI DT
ranges property", the following changes have been made:

 * Correct use of IORESOURCE_* as suggested by Russell King

 * Improved interface and naming as suggested by Thierry Reding

Compared to the v2 sent by Andrew Murray, Thomas Petazzoni did:

 * Add a memset() on the struct of_pci_range_iter when starting the
   for loop in for_each_pci_range(). Otherwise, with an uninitialized
   of_pci_range_iter, of_pci_process_ranges() may crash.

 * Add parenthesis around 'res', 'np' and 'iter' in the
   for_each_of_pci_range macro definitions. Otherwise, passing
   something like &foobar as 'res' didn't work.

 * Rebased on top of 3.9-rc2, which required fixing a few conflicts in
   the Microblaze code.

v2:
  This follows on from suggestions made by Grant Likely
  (marc.info/?l=linux-kernel&m=136079602806328)

Andrew Murray (3):
  of/pci: Unify pci_process_bridge_OF_ranges from Microblaze and
    PowerPC
  of/pci: Provide support for parsing PCI DT ranges property
  of/pci: mips: convert to common of_pci_range_parser

 arch/microblaze/include/asm/pci-bridge.h |    5 +-
 arch/microblaze/pci/pci-common.c         |  192 ------------------------------
 arch/mips/pci/pci.c                      |   50 +++------
 arch/powerpc/include/asm/pci-bridge.h    |    5 +-
 arch/powerpc/kernel/pci-common.c         |  192 ------------------------------
 drivers/of/address.c                     |   66 ++++++++++
 drivers/of/of_pci.c                      |  168 ++++++++++++++++++++++++++
 include/linux/of_address.h               |   46 +++++++
 include/linux/of_pci.h                   |    4 +
 9 files changed, 302 insertions(+), 426 deletions(-)

