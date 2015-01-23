Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbbAWUbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:31:51 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:64151 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbAWUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:31:49 -0500
Date: Fri, 23 Jan 2015 14:31:45 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>,
        Richard Zhu <Richard.Zhu@freescale.com>,
        Yinghai Lu <yinghai@kernel.org>, Marek Kordik <kordikmarek@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andreas Hartmann <andihartmann@freenet.de>, zermond@gmail.com,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [GIT PULL] PCI fixes for v3.19
Message-ID: <20150123203145.GA6691@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are fixes for:

  - A resource management problem that causes a Radeon "Fatal error during
    GPU init" on machines where the BIOS programmed an invalid Root Port
    window.  This was a regression in v3.16.

  - An Atheros AR93xx device that doesn't handle PCI bus resets correctly.
    This was a regression in v3.14.

  - An out-of-date email address.

Bjorn


The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.19-fixes-1

for you to fetch changes up to f175aa2c9f6cc08f043e85ea37f44ef3676cbac1:

  MAINTAINERS: Update Richard Zhu's email address (2015-01-22 13:40:59 -0600)

----------------------------------------------------------------
PCI updates for v3.19:

  Resource management
    - Clip bridge windows to fit in upstream windows (Yinghai Lu)

  Virtualization
    - Mark Atheros AR93xx to avoid using bus reset (Alex Williamson)

  Miscellaneous
    - Update Richard Zhu's email address (Lucas Stach)

----------------------------------------------------------------
Alex Williamson (2):
      PCI: Add flag for devices where we can't use bus reset
      PCI: Mark Atheros AR93xx to avoid bus reset

Lucas Stach (1):
      MAINTAINERS: Update Richard Zhu's email address

Yinghai Lu (12):
      PCI: Pass bridge device, not bus, when updating bridge windows
      PCI: Add pci_bus_clip_resource() to clip to fit upstream window
      PCI: Add pci_claim_bridge_resource() to clip window if necessary
      x86/PCI: Clip bridge windows to fit in upstream windows
      alpha/PCI: Clip bridge windows to fit in upstream windows
      frv/PCI: Clip bridge windows to fit in upstream windows
      ia64/PCI: Clip bridge windows to fit in upstream windows
      microblaze/PCI: Clip bridge windows to fit in upstream windows
      mn10300/PCI: Clip bridge windows to fit in upstream windows
      parisc/PCI: Clip bridge windows to fit in upstream windows
      powerpc/PCI: Clip bridge windows to fit in upstream windows
      sparc/PCI: Clip bridge windows to fit in upstream windows

 MAINTAINERS                             |  2 +-
 arch/alpha/kernel/pci.c                 |  8 +++--
 arch/frv/mb93090-mb00/pci-frv.c         |  2 +-
 arch/ia64/pci/pci.c                     | 48 +++++++++++++---------------
 arch/microblaze/pci/pci-common.c        | 13 +++++++-
 arch/mn10300/unit-asb2305/pci-asb2305.c |  2 +-
 arch/mn10300/unit-asb2305/pci.c         | 47 +++++++++++++--------------
 arch/powerpc/kernel/pci-common.c        | 12 ++++++-
 arch/sparc/kernel/pci.c                 |  5 ++-
 arch/x86/pci/i386.c                     |  2 +-
 drivers/parisc/lba_pci.c                |  5 ++-
 drivers/pci/bus.c                       | 43 +++++++++++++++++++++++++
 drivers/pci/pci.c                       | 40 ++++++++++++++++++++---
 drivers/pci/pci.h                       |  1 +
 drivers/pci/quirks.c                    | 14 +++++++++
 drivers/pci/setup-bus.c                 | 56 ++++++++++++++++++++++++++-------
 include/linux/pci.h                     |  3 ++
 17 files changed, 222 insertions(+), 81 deletions(-)
