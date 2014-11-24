Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbaKXFJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 00:09:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:54107 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaKXFJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 00:09:10 -0500
Message-ID: <1416805719.4998.15.camel@kernel.crashing.org>
Subject: linuxppc-dev list <linuxppc-dev@ozlabs.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Alex Deucher <alexdeucher@gmail.com>, Takashi Iwai <tiwai@suse.de>
Date: Mon, 24 Nov 2014 16:08:39 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This series fix a nasty issue with radeon adapters on powerpc servers,
it's all CC'ed stable and has the relevant maintainers ack's/reviews.

Basically, some (radeon) adapters have issues with MSI addresses above
1T (only support 40-bits). We had powerpc specific quirk but it only
listed a specific revision of an adapter that we shipped with our
machines and didn't properly handle the audio function which some distros
enable nowadays.

So we made the quirk generic and fixed both the graphic and audio drivers
properly to use it.

Without that, ppc64 server machines will crash at boot with a radeon adapter.

Note: This has been brewing for a while, it just needed a last respin which
got delayed due to us moving ozlabs to a new location in town and other such
things taking priority.

Cheers,
Ben.

The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:

  Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git 

for you to fetch changes up to 31345e1a071e4e5f2fa8b6be5ca7d1cbce20cfca:

  powerpc/pci: Remove unused force_32bit_msi quirk (2014-11-24 14:36:02 +1100)

----------------------------------------------------------------
Benjamin Herrenschmidt (6):
      PCI/MSI: Add device flag indicating that 64-bit MSIs don't work
      gpu/radeon: Set flag to indicate broken 64-bit MSI
      sound/radeon: Move 64-bit MSI quirk from arch to driver
      powerpc/powernv: Honor the generic "no_64bit_msi" flag
      powerpc/pseries: Honor the generic "no_64bit_msi" flag
      powerpc/pci: Remove unused force_32bit_msi quirk

Takashi Iwai (1):
      ALSA: hda - Limit 40bit DMA for AMD HDMI controllers

 arch/powerpc/include/asm/pci-bridge.h     |  2 --
 arch/powerpc/kernel/pci_64.c              | 10 ----------
 arch/powerpc/platforms/powernv/pci-ioda.c |  3 +--
 arch/powerpc/platforms/powernv/pci.c      |  3 +--
 arch/powerpc/platforms/pseries/msi.c      |  2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c   | 10 ++++++++++
 drivers/pci/msi.c                         | 26 ++++++++++++++++++++++++++
 include/linux/pci.h                       |  1 +
 sound/pci/hda/hda_intel.c                 | 24 +++++++++++++++++++-----
 sound/pci/hda/hda_priv.h                  |  1 +
 10 files changed, 60 insertions(+), 22 deletions(-)


