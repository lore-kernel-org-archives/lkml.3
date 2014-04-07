Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaDGTt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:49:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbaDGTt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:49:26 -0400
Date: Mon, 7 Apr 2014 21:49:22 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: haokexin@gmail.com, paul.gortmaker@windriver.com,
        yamada.m@jp.panasonic.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild changes for v3.15-rc1
Message-ID: <20140407194922.GA13995@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild bits for v3.15-rc1:
- Cleanups in the main Makefiles and Documentation/DocBook/Makefile
- make O=... directory is automatically created if needed
- mrproper/distclean removes the old include/linux/version.h to make
  life easier when bisecting across the commit that moved the version.h
  file

Thanks,
Michal

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to b12f73740b8764952a112a677991300545e98c06:

  kbuild: docbook: fix the include error when executing "make help" (2014-04-01 10:49:21 +0200)

----------------------------------------------------------------
Kevin Hao (1):
      kbuild: docbook: fix the include error when executing "make help"

Masahiro Yamada (7):
      kbuild: specify build_docproc as a phony target
      kbuild: docbook: include cmd files more simply
      kbuild: docbook: specify KERNELDOC dependency correctly
      kbuild: docbook: use $(obj) and $(src) rather than specific path
      kbuild: move "quote" to Kbuild.include to be consistent
      kbuild: remove redundant '.*.cmd' pattern from make distclean
      kbuild: create a build directory automatically for out-of-tree build

Paul Gortmaker (1):
      kbuild: unconditionally clobber include/linux/version.h on distclean

 Documentation/DocBook/Makefile | 25 +++++++------------------
 Makefile                       | 10 +++++-----
 scripts/Kbuild.include         |  1 +
 scripts/Makefile               |  6 +++---
 scripts/Makefile.lib           |  4 ----
 5 files changed, 16 insertions(+), 30 deletions(-)
