Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaHDHwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:52:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaHDHws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:52:48 -0400
Date: Mon, 4 Aug 2014 09:52:34 +0200
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Jason Baron <jbaron@akamai.com>, Fabian Frederick <fabf@skynet.be>,
        linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC queue for 3.17
Message-ID: <20140804075234.GA31482@pd.tnic>
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

--
The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.17

for you to fetch changes up to eba4bfb34d45a2219d1d7534905c026eea6fcd49:

  EDAC, MCE, AMD: Add MCE decoding for F15h M60h (2014-07-14 16:58:19 +0200)

----------------------------------------------------------------
EDAC queue for 3.17

* One new edac driver for Intel E3-12xx DRAM controllers.

Out-of-subsystem changes are making the non-atomic iomem 64-bit
accessors' naming explicit to show both exact order of the 32-bit
accesses and the non-atomicity of the 64-bit access.

Usage locations are more verbose now as to what access is exactly being
done vs having a not-very telling "readq" there, for example.

This is needed by E3-12xx hardware where certain mmapped registers
cannot be accessed with requests crossing a dword boundary.

>From Jason Baron.

* Extending AMD MCE signatures to a new model 60h in family 15h, from
Aravind Gopalakrishnan.

* An unsigned check cleanup, from Fabian Frederick.

----------------------------------------------------------------
Aravind Gopalakrishnan (1):
      EDAC, MCE, AMD: Add MCE decoding for F15h M60h

Fabian Frederick (1):
      EDAC, edac_module.c: Remove unnecessary test on unsigned value

Jason Baron (5):
      readq/writeq: Add explicit lo_hi_[read|write]_q and hi_lo_[read|write]_q
      x38_edac: make use of lo_hi_readq()
      ie31200_edac: Introduce the driver
      ie31200_edac: Allocate mci and map mchbar first
      MAINTAINERS: add ie31200_edac entry

 MAINTAINERS                                 |   7 +
 drivers/edac/Kconfig                        |   7 +
 drivers/edac/Makefile                       |   1 +
 drivers/edac/edac_module.c                  |   2 +-
 drivers/edac/ie31200_edac.c                 | 536 ++++++++++++++++++++++++++++
 drivers/edac/mce_amd.c                      |  44 ++-
 drivers/edac/x38_edac.c                     |  15 +-
 include/asm-generic/io-64-nonatomic-hi-lo.h |  14 +-
 include/asm-generic/io-64-nonatomic-lo-hi.h |  14 +-
 9 files changed, 616 insertions(+), 24 deletions(-)
 create mode 100644 drivers/edac/ie31200_edac.c

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
