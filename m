Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaHKPLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:11:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbaHKPL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:11:29 -0400
Date: Mon, 11 Aug 2014 17:11:25 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ak@linux.intel.com, behanw@converseincode.com, mmarek@suse.cz,
        yamada.m@jp.panasonic.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild for 3.17-rc1
Message-ID: <20140811151125.GA4302@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following kbuild changes for 3.17-rc1:
- make clean also considers $(extra-m) and $(extra-) to be consistent
- Cleanup and fixes in scripts/Makefile.host
- Allow to override the name of the Python 2 executable with make
  PYTHON=... (only needed for ia64 in practice)
- Option to split debugingo into *.dwo files to save disk space if the
  compiler supports it (CONFIG_DEBUG_INFO_SPLIT)
- Option to use dwarf4 debuginfo if the compiler supports it
  (CONFIG_DEBUG_INFO_DWARF4)
- Fix for disabling certain warnings with clang
- Fix for unneeded rebuild with dash when a command contains backslashes

Michal

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to 164f0d2efaaef835473e74b162eae750341d6a8c:

  kbuild: Fix handling of backslashes in *.cmd files (2014-08-07 21:53:20 +0200)

----------------------------------------------------------------
Andi Kleen (2):
      kbuild: Support split debug info v4
      Kbuild: Add a option to enable dwarf4 v2

Behan Webster (1):
      kbuild, LLVMLinux: Supress warnings unless W=1-3

Masahiro Yamada (7):
      scripts/Makefile.clean: clean also $(extra-m) and $(extra-)
      kbuild: fix a typo in scripts/Makefile.host
      kbuild: fix a bug of C++ host program handling
      kbuild: drop shared library support from Makefile.host
      kbuild: clean up scripts/Makefile.host
      kbuild: clean-up and bug fix of scripts/Makefile.host
      kbuild: allow to override Python command name

Michal Marek (1):
      kbuild: Fix handling of backslashes in *.cmd files

 .gitignore                         |  1 +
 Documentation/kbuild/makefiles.txt | 39 +++++-------------------
 Makefile                           | 12 +++++++-
 arch/ia64/Makefile                 |  2 +-
 lib/Kconfig.debug                  | 24 +++++++++++++++
 scripts/Kbuild.include             | 14 +++++----
 scripts/Makefile.clean             |  4 +--
 scripts/Makefile.extrawarn         | 21 ++++++-------
 scripts/Makefile.host              | 61 ++++++--------------------------------
 9 files changed, 75 insertions(+), 103 deletions(-)
