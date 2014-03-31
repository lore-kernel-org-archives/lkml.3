Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaCaM41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:56:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaCaM4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:56:09 -0400
Date: Mon, 31 Mar 2014 14:55:59 +0200
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] EDAC for 3.15
Message-ID: <20140331125559.GA16144@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the EDAC pile which has been trickling down slowly for a
while now.

Thanks.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.15

for you to fetch changes up to 85a8885bd0e00569108aa7b5e26b89c752e3cd51:

  amd64_edac: Add support for newer F16h models (2014-02-27 18:03:16 +0100)

----------------------------------------------------------------
A bunch of EDAC updates all over the place:

* Support for new AMD models, along with more graceful fallback for
unsupported hw.

* Bunch of fixes from SUSE accumulated from bug reports

* Misc other fixes and cleanups

----------------------------------------------------------------
Aravind Gopalakrishnan (2):
      amd64_edac: Fix logic to determine channel for F15 M30h processors
      amd64_edac: Add support for newer F16h models

Aristeu Rozanski (1):
      i5400_edac: Disable device when unloading module

Borislav Petkov (1):
      MCE, AMD: Fix decoding module loading on unsupported hw

Dan Carpenter (1):
      i5100_edac: Remove an unneeded condition in i5100_init_csrows()

Hitoshi Mitake (1):
      i3200_edac: Add a missing pci_disable_device() on the exit path

Jean Delvare (5):
      e752x_edac: Simplify call to pci_get_device()
      e752x_edac: Drop pvt->bridge_ck
      amd8111_edac: Fix leaks in probe error paths
      i82875p_edac: Drop redundant call to pci_get_device()
      i7core_edac: Drop unused variable

Jiang Liu (1):
      sb_edac: Degrade log level for device registration

Johannes Thumshirn (1):
      edac/85xx: Remove deprecated IRQF_DISABLED

 arch/x86/kernel/amd_nb.c    |  2 ++
 drivers/edac/amd64_edac.c   | 38 +++++++++++++++++++++++---
 drivers/edac/amd64_edac.h   |  3 +++
 drivers/edac/amd8111_edac.c | 44 ++++++++++++++++++++----------
 drivers/edac/e752x_edac.c   | 30 ++++++++-------------
 drivers/edac/i3200_edac.c   |  2 ++
 drivers/edac/i5100_edac.c   | 17 +++++-------
 drivers/edac/i5400_edac.c   |  2 ++
 drivers/edac/i7core_edac.c  | 10 +++----
 drivers/edac/i82875p_edac.c |  2 --
 drivers/edac/mce_amd.c      | 65 +++++++++++++++++++++++----------------------
 drivers/edac/mpc85xx_edac.c |  6 ++---
 drivers/edac/sb_edac.c      |  2 +-
 include/linux/pci_ids.h     |  2 ++
 14 files changed, 134 insertions(+), 91 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
