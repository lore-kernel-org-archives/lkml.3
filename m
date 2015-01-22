Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbbAVVEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:04:00 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:41292 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbAVVD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:03:56 -0500
Date: Thu, 22 Jan 2015 15:03:44 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-pci@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>,
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
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, cbe-oss-dev@lists.ozlabs.org,
        linux-am33-list@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 00/16] PCI generic configuration space accessors
Message-ID: <20150122210344.GE13072@google.com>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 08:34:34PM -0600, Rob Herring wrote:
> This series adds common accessor functions for PCI configuration space
> accesses. This supports most PCI hosts with memory mapped configuration
> space like ECAM or hosts with memory mapped address/data registers. ECAM
> is not generically supported by this series, but could be added on top
> of this. While some hosts have standard address decoding which could be 
> common as well, the various checks on bus numbers and device numbers are 
> quite varied. It is unclear how much of that is really necessary or 
> could be common. 
> 
> The first 4 patches are preparatory cleanup. Patch 5 introduces the
> common accessors. The remaining patches convert several PCI host
> controllers. This is in no way a complete list of host controllers. The
> conversion of more hosts should be possible. The Designware controller
> in particular should be able to be converted, but its config space
> accessors are a mess of override-able functions that I've not gotten my
> head around.
> 
> This series is available here [1].
> 
> Rob
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git pci-config-access
> 
> Rob Herring (16):
>   frv: add struct pci_ops member names to initialization
>   mips: add struct pci_ops member names to initialization
>   mn10300: add struct pci_ops member names to initialization
>   powerpc: add struct pci_ops member names to initialization
>   pci: introduce common pci config space accessors
>   ARM: cns3xxx: convert PCI to use generic config accesses
>   ARM: integrator: convert PCI to use generic config accesses
>   ARM: sa1100: convert PCI to use generic config accesses
>   ARM: ks8695: convert PCI to use generic config accesses
>   powerpc: fsl_pci: convert PCI to use generic config accesses
>   powerpc: powermac: convert PCI to use generic config accesses
>   pci/host: generic: convert to use generic config accesses
>   pci/host: rcar-gen2: convert to use generic config accesses
>   pci/host: tegra: convert to use generic config accesses
>   pci/host: xgene: convert to use generic config accesses
>   pci/host: xilinx: convert to use generic config accesses
> 
>  arch/arm/mach-cns3xxx/pcie.c                   |  52 ++----
>  arch/arm/mach-integrator/pci_v3.c              |  61 +-------
>  arch/arm/mach-ks8695/pci.c                     |  77 +--------
>  arch/arm/mach-sa1100/pci-nanoengine.c          |  94 +----------
>  arch/frv/mb93090-mb00/pci-vdk.c                |   4 +-
>  arch/mips/pci/pci-bcm1480.c                    |   4 +-
>  arch/mips/pci/pci-octeon.c                     |   4 +-
>  arch/mips/pci/pcie-octeon.c                    |  12 +-
>  arch/mn10300/unit-asb2305/pci.c                |   4 +-
>  arch/powerpc/platforms/cell/celleb_scc_pciex.c |   4 +-
>  arch/powerpc/platforms/powermac/pci.c          | 209 +++++--------------------
>  arch/powerpc/sysdev/fsl_pci.c                  |  46 +-----
>  drivers/pci/access.c                           |  87 ++++++++++
>  drivers/pci/host/pci-host-generic.c            |  51 +-----
>  drivers/pci/host/pci-rcar-gen2.c               |  51 +-----
>  drivers/pci/host/pci-tegra.c                   |  55 +------
>  drivers/pci/host/pci-xgene.c                   | 150 ++----------------
>  drivers/pci/host/pcie-xilinx.c                 |  88 ++---------
>  include/linux/pci.h                            |  11 ++
>  19 files changed, 212 insertions(+), 852 deletions(-)

Really nice cleanups.  I added these with the acks so far to a pci/config
branch for v3.20.  I'll update it with more acks if they trickle in.

You've structured it nicely so I can also just drop individual arch pieces
if necessary.  The pieces that haven't been acked yet (hint, hint):

    arch/arm/mach-cns3xxx/pcie.c
    arch/arm/mach-sa1100/pci-nanoengine.c
    arch/mn10300/unit-asb2305/pci.c
    arch/powerpc

In addition, nobody has acked the frv and mips parts, but they're trivial
(they only add struct member names) that I can apply them without worrying.

Bjorn
