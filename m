Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbbAJCf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:35:29 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39341 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbbAJCf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:27 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Simek <michal.simek@xilinx.com>,
        Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, cbe-oss-dev@lists.ozlabs.org,
        linux-am33-list@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH 00/16] PCI generic configuration space accessors
Date: Fri,  9 Jan 2015 20:34:34 -0600
Message-Id: <1420857290-8373-1-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds common accessor functions for PCI configuration space
accesses. This supports most PCI hosts with memory mapped configuration
space like ECAM or hosts with memory mapped address/data registers. ECAM
is not generically supported by this series, but could be added on top
of this. While some hosts have standard address decoding which could be 
common as well, the various checks on bus numbers and device numbers are 
quite varied. It is unclear how much of that is really necessary or 
could be common. 

The first 4 patches are preparatory cleanup. Patch 5 introduces the
common accessors. The remaining patches convert several PCI host
controllers. This is in no way a complete list of host controllers. The
conversion of more hosts should be possible. The Designware controller
in particular should be able to be converted, but its config space
accessors are a mess of override-able functions that I've not gotten my
head around.

This series is available here [1].

Rob

[1] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git pci-config-access

Rob Herring (16):
  frv: add struct pci_ops member names to initialization
  mips: add struct pci_ops member names to initialization
  mn10300: add struct pci_ops member names to initialization
  powerpc: add struct pci_ops member names to initialization
  pci: introduce common pci config space accessors
  ARM: cns3xxx: convert PCI to use generic config accesses
  ARM: integrator: convert PCI to use generic config accesses
  ARM: sa1100: convert PCI to use generic config accesses
  ARM: ks8695: convert PCI to use generic config accesses
  powerpc: fsl_pci: convert PCI to use generic config accesses
  powerpc: powermac: convert PCI to use generic config accesses
  pci/host: generic: convert to use generic config accesses
  pci/host: rcar-gen2: convert to use generic config accesses
  pci/host: tegra: convert to use generic config accesses
  pci/host: xgene: convert to use generic config accesses
  pci/host: xilinx: convert to use generic config accesses

 arch/arm/mach-cns3xxx/pcie.c                   |  52 ++----
 arch/arm/mach-integrator/pci_v3.c              |  61 +-------
 arch/arm/mach-ks8695/pci.c                     |  77 +--------
 arch/arm/mach-sa1100/pci-nanoengine.c          |  94 +----------
 arch/frv/mb93090-mb00/pci-vdk.c                |   4 +-
 arch/mips/pci/pci-bcm1480.c                    |   4 +-
 arch/mips/pci/pci-octeon.c                     |   4 +-
 arch/mips/pci/pcie-octeon.c                    |  12 +-
 arch/mn10300/unit-asb2305/pci.c                |   4 +-
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |   4 +-
 arch/powerpc/platforms/powermac/pci.c          | 209 +++++--------------------
 arch/powerpc/sysdev/fsl_pci.c                  |  46 +-----
 drivers/pci/access.c                           |  87 ++++++++++
 drivers/pci/host/pci-host-generic.c            |  51 +-----
 drivers/pci/host/pci-rcar-gen2.c               |  51 +-----
 drivers/pci/host/pci-tegra.c                   |  55 +------
 drivers/pci/host/pci-xgene.c                   | 150 ++----------------
 drivers/pci/host/pcie-xilinx.c                 |  88 ++---------
 include/linux/pci.h                            |  11 ++
 19 files changed, 212 insertions(+), 852 deletions(-)

-- 
2.1.0

