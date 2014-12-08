Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaLHMgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:36:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaLHMgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:36:51 -0500
Date: Mon, 8 Dec 2014 13:36:48 +0100
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC queue for 3.19
Message-ID: <20141208123648.GC20057@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull,
thanks.

---
The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.19

for you to fetch changes up to 50872ccd8786dc72bc5a32c17695561e031fae4c:

  EDAC, MCE, AMD: Correct formatting of decoded text (2014-11-25 13:09:49 +0100)

----------------------------------------------------------------
EDAC updates all over the place:

* Enablement for AMD F15h models 0x60 CPUs. Most notably DDR4 RAM
support. Out of tree stuff is

 arch/x86/kernel/amd_nb.c       |   2 +
 include/linux/pci_ids.h        |   2 +

adding the required PCI IDs. From Aravind Gopalakrishnan.

* Enable amd64_edac for 32-bit due to popular demand. From Tomasz Pala.

* Convert the AMD MCE injection module to debugfs, where it belongs.

* Misc EDAC cleanups

----------------------------------------------------------------
Andreas Ruprecht (1):
      EDAC, pci_sysfs: remove unneccessary ifdef around entire file

Aravind Gopalakrishnan (5):
      pci_ids: Add PCI device IDs for F15h M60h
      x86, amd_nb: Add device IDs to NB tables for F15h M60h
      EDAC: Add DDR3 LRDIMM entries to edac_mem_types
      amd64_edac: Add F15h M60h support
      EDAC, MCE, AMD: Add decoding table for MC6 xec

Borislav Petkov (6):
      EDAC: Sync memory types and names
      EDAC, mce_amd_inj: Convert mce_amd_inj module to debugfs
      EDAC, mce_amd_inj: Enable direct writes to MCE MSRs
      EDAC, mce_amd_inj: Add hw-injection attributes
      EDAC, mce_amd_inj: Add an injector function
      EDAC, MCE, AMD: Correct formatting of decoded text

Dan Carpenter (1):
      ghes_edac: Use snprintf() to silence a static checker warning

Markus Elfring (1):
      EDAC: Delete unnecessary check before calling pci_dev_put()

Michael Opdenacker (1):
      {mv64x60,ppc4xx}_edac,: Remove deprecated IRQF_DISABLED

Tomasz Pala (1):
      amd64_edac: Build module on x86-32

 arch/x86/kernel/amd_nb.c       |   2 +
 drivers/edac/Kconfig           |  16 +--
 drivers/edac/Makefile          |   2 +-
 drivers/edac/amd64_edac.c      | 260 +++++++++++++++++++++++++-----------
 drivers/edac/amd64_edac.h      |  15 ++-
 drivers/edac/edac_mc.c         |  40 +++---
 drivers/edac/edac_pci_sysfs.c  |   5 -
 drivers/edac/ghes_edac.c       |   4 +-
 drivers/edac/i3000_edac.c      |   3 +-
 drivers/edac/i3200_edac.c      |   3 +-
 drivers/edac/i82443bxgx_edac.c |   3 +-
 drivers/edac/mce_amd.c         |  47 ++-----
 drivers/edac/mce_amd_inj.c     | 293 +++++++++++++++++++++++++++--------------
 drivers/edac/mv64x60_edac.c    |   8 +-
 drivers/edac/ppc4xx_edac.c     |   4 +-
 drivers/edac/x38_edac.c        |   3 +-
 include/linux/edac.h           |   4 +-
 include/linux/pci_ids.h        |   2 +
 18 files changed, 446 insertions(+), 268 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
