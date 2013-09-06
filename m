Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3IFU3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:29:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab3IFU3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:29:14 -0400
Date: Fri, 6 Sep 2013 22:29:12 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: anisse@astier.eu, jcmvbkbc@gmail.com, linux@rasmusvillemoes.dk,
        mike.marciniszyn@intel.com, xypron.glpk@gmx.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc updates for v3.12-rc1
Message-ID: <20130906202912.GA11225@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

in the kbuild misc branch, I have:
- make rpm-pkg updates, most importantly the rpm package now calls
  /sbin/installkernel
- make deb-pkg: debuginfo split, correct kernel image path for parisc,
  mips and powerpc and a couple more minor fixes
- New coccinelle check

Thanks,
Michal

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

Anisse Astier (4):
      deb-pkg: use KCONFIG_CONFIG instead of .config file directly
      deb-pkg: split debug symbols in their own package
      deb-pkg: fix installed image path on parisc, mips and powerpc
      deb-pkg: add a hook argument to match debian hooks parameters

Heinrich Schuchardt (1):
      Provide version number for Debian firmware package

Max Filippov (1):
      scripts/checkkconfigsymbols.sh: replace echo -e with printf

Mike Marciniszyn (3):
      rpm-pkg: add %post section to create initramfs and grub hooks
      rpm-pkg: install firmware files in kernel relative directory
      rpm-pkg: add generation of kernel-devel

Rasmus Villemoes (1):
      coccinelle: replace 0/1 with false/true in functions returning bool

 scripts/checkkconfigsymbols.sh           |    4 +-
 scripts/coccinelle/misc/boolreturn.cocci |   58 ++++++++++++++++++
 scripts/package/builddeb                 |   94 +++++++++++++++++++++++++-----
 scripts/package/mkspec                   |   46 +++++++++++++--
 4 files changed, 178 insertions(+), 24 deletions(-)
 create mode 100644 scripts/coccinelle/misc/boolreturn.cocci
