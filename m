Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab3DZJm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:42:58 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:43380 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab3DZJmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:42:54 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au>
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au>
Date: Fri, 26 Apr 2013 11:42:52 +0200
Message-ID: <CA+icZUWt_W5FUQgQ2TFoQU0df+sAbxZZE8AcD16T3f_fiTD9DQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 26
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130424:
>
> Removed tree: ppc-temp (remerged into powerpc)
>
> The net-next tree gained conflicts against the net and pci trees and a
> build failure for which I applied a merge fix patch.
>
> The omap_dss2 tree gained a build failure so I used the version from
> next-20130424.
>
> The trivial tree gained a conflict against the arm tree.
>
> The staging tree still had its build failure for which I applied a
> supplied patch.
>
> The arm-soc tree gained a conflict against the spi-mb tree.
>
> The renesas tree gained a conflict against the input tree.
>
> ----------------------------------------------------------------------------
>

[ CC linux-kbuild folks ]

I am always doing a ...

   $ cd linux-next/

   $ yes "" | make oldconfig

... before starting a kernel-build.

Today, I see this ...

$ ./scripts/build_linux-next.sh
make options ...... CC=gcc-4.6 -j4
KBUILD_BUILD_USER=sedat.dilek@gmail.com
LOCALVERSION=-next20130426-1-iniza-small
dep-pkg options ... KDEB_PKGVERSION=3.9.0~rc8~next20130426-1~iniza+dileks1
scripts/kconfig/conf --silentoldconfig Kconfig
*
* Restart config...
*
*
* Bus options (PCI etc.)
*
PCI support (PCI) [Y/n/?] y
  Support mmconfig PCI config space access (PCI_MMCONFIG) [Y/n] y
  Read CNB20LE Host Bridge Windows (PCI_CNB20LE_QUIRK) [N/y/?] n
  PCI Express support (PCIEPORTBUS) [Y/n/?] y
    PCI Express Hotplug driver (HOTPLUG_PCI_PCIE) [Y/n/m/?] y
    Root Port Advanced Error Reporting support (PCIEAER) [Y/n/?] y
      PCI Express ECRC settings control (PCIE_ECRC) [N/y/?] n
      PCIe AER error injector support (PCIEAER_INJECT) [N/m/y/?] n
    PCI Express ASPM control (PCIEASPM) [Y/n/?] y
      Debug PCI Express ASPM (PCIEASPM_DEBUG) [N/y/?] n
      Default ASPM policy
      > 1. BIOS default (PCIEASPM_DEFAULT)
        2. Powersave (PCIEASPM_POWERSAVE)
        3. Performance (PCIEASPM_PERFORMANCE)
      choice[1-3]: 1
Message Signaled Interrupts (MSI and MSI-X) (PCI_MSI) [Y/?] y
PCI Debugging (PCI_DEBUG) [N/y/?] n
Enable PCI resource re-allocation detection (PCI_REALLOC_ENABLE_AUTO) [Y/n/?] y
PCI Stub driver (PCI_STUB) [N/m/y/?] n
Xen PCI Frontend (XEN_PCIDEV_FRONTEND) [N/m/y/?] n
Interrupts on hypertransport devices (HT_IRQ) [Y/n/?] y
PCI IOV support (PCI_IOV) [Y/n/?] y
PCI PRI support (PCI_PRI) [Y/?] y
PCI PASID support (PCI_PASID) [Y/?] y
PCI IO-APIC hotplug support (PCI_IOAPIC) [Y/n/m] y
ISA-style DMA support (ISA_DMA_API) [Y/n/?] y
RapidIO support (RAPIDIO) [Y/n/?] y
  IDT Tsi721 PCI Express SRIO Controller support (RAPIDIO_TSI721) [Y/n/?] y
  Discovery timeout duration (seconds) (RAPIDIO_DISC_TIMEOUT) [30] 30
  Enable RapidIO Input/Output Ports (RAPIDIO_ENABLE_RX_TX_PORTS) [N/y/?] n
  DMA Engine support for RapidIO (RAPIDIO_DMA_ENGINE) [Y/n/?] y
  RapidIO subsystem debug messages (RAPIDIO_DEBUG) [N/y/?] n
  Enumeration method [M/y/?] (NEW) aborted!

Console input/output is redirected. Run 'make oldconfig' to update
configuration.

make[2]: *** [silentoldconfig] Error 1
make[1]: *** [silentoldconfig] Error 2
make: *** No rule to make target `include/config/auto.conf', needed by
`include/config/kernel.release'.  Stop.

Had only a quick view!

Temp. workaround: cd build-dir, run manually 'make oldconfig'.

Explanations welcome :-)!

Have fun!

- Sedat -
