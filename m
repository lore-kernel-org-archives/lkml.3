Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022Ab3B0NQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:16:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759943Ab3B0NQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:16:11 -0500
Date: Wed, 27 Feb 2013 14:16:01 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ak@linux.intel.com, christophe.leroy@c-s.fr, hpa@zytor.com,
        james.hogan@imgtec.com, jesper.nilsson@axis.com,
        m.grzeschik@pengutronix.de, mmarek@suse.cz, schwab@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild changes for v3.9-rc1
Message-ID: <20130227131600.GA31783@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild changes for v3.9-rc1:

* Alias generation in modpost is cross-compile safe.
* kernel/timeconst.h is now generated using a bc script instead of perl.
* scripts/link-vmlinux.sh now works with an alternative $KCONFIG_CONFIG.
* destination-y for exported headers is supported in Kbuild files again.
* depmod is called with -P $CONFIG_SYMBOL_PREFIX on architectures that
  need it.
* CONFIG_DEBUG_INFO_REDUCED disables var-tracking
* scripts/setlocalversion works with too much translated locales ;)

Michal

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to 423a8155facf23719078ff63911c1e85ba40970b:

  kbuild: Fix reading of .config in link-vmlinux.sh (2013-02-25 16:14:48 +0100)

----------------------------------------------------------------
Andi Kleen (1):
      Kbuild: Disable var tracking with CONFIG_DEBUG_INFO_REDUCED

Andreas Schwab (1):
      mod/file2alias: make modalias generation safe for cross compiling

Christophe Leroy (1):
      kbuild: Unset language specific variables in setlocalversion script

H. Peter Anvin (1):
      kernel: Replace timeconst.pl with a bc script

James Hogan (1):
      depmod: pass -P $CONFIG_SYMBOL_PREFIX

Jesper Nilsson (1):
      kbuild: Fix destination-y for installed headers

Michael Grzeschik (1):
      scripts/link-vmlinux.sh: source variables from KCONFIG_CONFIG

Michal Marek (1):
      kbuild: Fix reading of .config in link-vmlinux.sh

 Makefile                          |    6 +-
 include/linux/mod_devicetable.h   |   58 +---
 kernel/Makefile                   |   16 +-
 kernel/timeconst.bc               |  108 ++++++
 kernel/timeconst.pl               |  378 ---------------------
 scripts/Makefile.headersinst      |    6 +-
 scripts/Makefile.modpost          |    7 +-
 scripts/depmod.sh                 |   26 +-
 scripts/link-vmlinux.sh           |    9 +-
 scripts/mod/.gitignore            |    1 +
 scripts/mod/Makefile              |   35 ++
 scripts/mod/devicetable-offsets.c |  178 ++++++++++
 scripts/mod/file2alias.c          |  674 ++++++++++++++++++++-----------------
 scripts/mod/modpost.c             |    5 +-
 scripts/setlocalversion           |    2 +-
 15 files changed, 749 insertions(+), 760 deletions(-)
 create mode 100644 kernel/timeconst.bc
 delete mode 100644 kernel/timeconst.pl
 create mode 100644 scripts/mod/devicetable-offsets.c
