Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaDGUTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:19:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaDGUTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:19:21 -0400
Date: Mon, 7 Apr 2014 22:19:19 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ak@linux.intel.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140407201919.GA15838@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

besides the kbuild branch, here is the LTO build support by Andi. It is
a separate branch, because it depends on other patches by Andi which
were merged through other trees. The link-time-optimization build is an
experimental feature, so there one kconfig option to enable it and
another kconfig option to disable it (behind a door with a sign "Beware
of the Leopard"...), so that it is not enabled by
allmodconfig/allyesconfig.

Thanks,
Michal

The following changes since commit 176ab02d4916f09d5d8cb63372d142df4378cdea:

  Merge branch 'x86-asmlinkage-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-03-31 14:13:25 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git lto

for you to fetch changes up to 19a3cc83353e3bb4bc28769f8606139a3d350d2d:

  Kbuild, lto: Add Link Time Optimization support v3 (2014-04-07 21:51:13 +0200)

----------------------------------------------------------------
Andi Kleen (2):
      Kbuild, lto: Set TMPDIR for LTO v4
      Kbuild, lto: Add Link Time Optimization support v3

 Documentation/lto-build  | 173 +++++++++++++++++++++++++++++++++++++++++++++++
 Makefile                 |  20 +++++-
 arch/x86/Kconfig         |   2 +-
 init/Kconfig             |  73 ++++++++++++++++++++
 kernel/gcov/Kconfig      |   2 +-
 lib/Kconfig.debug        |   2 +-
 scripts/Makefile.lto     |  84 +++++++++++++++++++++++
 scripts/Makefile.modpost |   7 +-
 scripts/link-vmlinux.sh  |   2 +-
 9 files changed, 357 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/lto-build
 create mode 100644 scripts/Makefile.lto
