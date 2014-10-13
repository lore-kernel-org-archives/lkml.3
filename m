Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaJMUI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:08:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaJMUIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:08:24 -0400
Date: Mon, 13 Oct 2014 22:08:20 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Julia.Lawall@lip6.fr, asbjorn@asbjorn.biz, dirk@gouders.net,
        geert@linux-m68k.org, mikey@neuling.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild misc changes for v3.17-rc1
Message-ID: <20141013200820.GA16791@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the less critical kbuild stuff for v3.18-rc1:

* make deb-pkg debuginfo fix, ppc64el support and warning fix for recent
  dpkg tools
* make TAGS fixes
* new coccinelle patch
* kbuild documentation improvements

There is a trivial conflict in scripts/tags.sh

Michal


The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

for you to fetch changes up to 4204111c028d492019e4440d12e9e3d062db4283:

  deb-pkg: remove obsolete -isp option to dpkg-gencontrol (2014-10-06 18:02:39 +0200)

----------------------------------------------------------------
Asbjoern Sloth Toennesen (1):
      deb-pkg: remove obsolete -isp option to dpkg-gencontrol

Dirk Gouders (3):
      scripts/tags.sh: Don't specify kind-spec for emacs' ctags/etags
      scripts/tags.sh: remove *PCGFLAGS regular expressions
      scripts/tags.sh: fix DEFINE_HASHTABLE in emacs case

Geert Uytterhoeven (4):
      Documentation: kbuild: Remove obsolete include/asm symlink step
      Documentation: kbuild: Improve if_changed documentation
      Documentation: kbuild: Remove obsolete dtc_cpp section
      Documentation: kbuild: Improve grammar

Julia Lawall (1):
      coccinelle: misc: semantic patch to delete overly complex return code processing

Michael Neuling (1):
      deb-pkg: Add support for powerpc little endian

Michal Marek (1):
      builddeb: put the dbg files into the correct directory

 Documentation/kbuild/makefiles.txt          |  94 ++++++---------
 scripts/coccinelle/misc/simple_return.cocci | 180 ++++++++++++++++++++++++++++
 scripts/package/builddeb                    |  26 ++--
 scripts/tags.sh                             |  10 +-
 4 files changed, 228 insertions(+), 82 deletions(-)
 create mode 100644 scripts/coccinelle/misc/simple_return.cocci
