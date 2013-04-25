Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3DYJuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:50:07 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:58533 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755292Ab3DYJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:50:06 -0400
From: Andrew Murray <Andrew.Murray@arm.com>
To: linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au
Cc: benh@kernel.crashing.org, monstr@monstr.eu, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, grant.likely@secretlab.ca,
        Andrew Murray <Andrew.Murray@arm.com>
Subject: [RFC PATCH 0/3] Unify definations of struct pci_controller
Date: Thu, 25 Apr 2013 10:49:17 +0100
Message-Id: <1366883360-14061-1-git-send-email-Andrew.Murray@arm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC and Microblaze have nearly identical definations of struct
pci_controller - this patch unifies them in asm-generic to reduce
code duplication and to allow new architectures to reuse.

This patchset follows and depends on "of/pci: Provide common
support for PCI DT parsing" which provided common 'ranges' parsing
code which uses an architecture defined struct pci_controller. This
patch is currently in Jason Coopers mvebu-next/pcie branch.

It is hoped this will pave the way for providing common
implementations of commonly duplicated functions found across the
architectures such as pcibios_alloc|free_controller and
pcibios_setup_phb_resources type functions.

Andrew Murray (3):
  powerpc: Move struct pci_controller to asm-generic
  microblaze: Use asm-generic version of pci_controller
  pci: Use common definations of INDIRECT_TYPE_*

 arch/microblaze/include/asm/pci-bridge.h |   70 +-----------------------
 arch/powerpc/include/asm/pci-bridge.h    |   82 ---------------------------
 arch/powerpc/sysdev/fsl_pci.c            |   16 +++---
 arch/powerpc/sysdev/indirect_pci.c       |   20 +++---
 arch/powerpc/sysdev/ppc4xx_pci.c         |    4 +-
 arch/powerpc/sysdev/xilinx_pci.c         |    2 +-
 include/asm-generic/pci-bridge.h         |   90 ++++++++++++++++++++++++++++++
 7 files changed, 112 insertions(+), 172 deletions(-)

