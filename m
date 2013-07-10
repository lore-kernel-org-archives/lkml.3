Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab3GJOIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:08:39 -0400
Received: from ip-78-102-49-28.net.upcbroadband.cz ([78.102.49.28]:64953 "EHLO
	emu.suse.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754046Ab3GJOIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:08:37 -0400
Date: Wed, 10 Jul 2013 16:08:30 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Julia.Lawall@lip6.fr, keescook@chromium.org, nicolas.palix@imag.fr,
        strnape1@fel.cvut.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] coccinelle updates for v3.11-rc1
Message-ID: <20130710140830.GA32360@emu.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the misc branch is reserved for Coccinelle this time:

- 'report' is the default mode
- MAINTAINERS update for Coccinelle
- documentation udate
- use new option format for spatch(1)
- J=<n> variable to mimic make -j for coccicheck
- check for missing pci_free_consistent() calls

There are some patches for rpm-pkg and deb-pkg waiting for the 3.12-rc1
merge window.

Michal

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

for you to fetch changes up to ec97946ed038f4b3faa587bc76152b198805b0c4:

  Coccinelle: Update information about the minimal version required (2013-07-03 22:58:20 +0200)

----------------------------------------------------------------
Julia Lawall (1):
      scripts/coccinelle: check for field address argument to kfree

Kees Cook (1):
      coccicheck: span checks across CPUs

Nicolas Palix (6):
      Coccinelle: Make 'report' the default mode
      Coccinelle: Update the Coccinelle section of MAINTAINERS
      Coccinelle: Update section of MAINTAINERS
      Coccinelle: Update the documentation
      Coccinelle: Update the options used to the new option scheme
      Coccinelle: Update information about the minimal version required

strnape1@fel.cvut.cz (1):
      scripts: Coccinelle script for pci_free_consistent()

 Documentation/coccinelle.txt                       | 63 +++++++++++-------
 MAINTAINERS                                        |  3 +
 scripts/coccicheck                                 | 76 ++++++++++++++++------
 .../coccinelle/api/alloc/drop_kmalloc_cast.cocci   |  2 +-
 scripts/coccinelle/api/alloc/kzalloc-simple.cocci  |  2 +-
 scripts/coccinelle/api/d_find_alias.cocci          |  2 +-
 .../coccinelle/api/devm_request_and_ioremap.cocci  |  2 +-
 scripts/coccinelle/api/kstrdup.cocci               |  2 +-
 scripts/coccinelle/api/memdup.cocci                |  2 +-
 scripts/coccinelle/api/memdup_user.cocci           |  2 +-
 scripts/coccinelle/api/ptr_ret.cocci               |  2 +-
 scripts/coccinelle/api/simple_open.cocci           |  2 +-
 scripts/coccinelle/free/devm_free.cocci            |  2 +-
 scripts/coccinelle/free/kfree.cocci                |  2 +-
 scripts/coccinelle/free/kfreeaddr.cocci            | 32 +++++++++
 scripts/coccinelle/free/pci_free_consistent.cocci  | 52 +++++++++++++++
 scripts/coccinelle/iterators/fen.cocci             |  2 +-
 scripts/coccinelle/iterators/itnull.cocci          |  2 +-
 .../coccinelle/iterators/list_entry_update.cocci   |  2 +-
 scripts/coccinelle/iterators/use_after_iter.cocci  |  2 +-
 scripts/coccinelle/locks/call_kern.cocci           |  2 +-
 scripts/coccinelle/locks/double_lock.cocci         |  2 +-
 scripts/coccinelle/locks/flags.cocci               |  2 +-
 scripts/coccinelle/locks/mini_lock.cocci           |  2 +-
 scripts/coccinelle/misc/boolinit.cocci             |  2 +-
 scripts/coccinelle/misc/cstptr.cocci               |  2 +-
 scripts/coccinelle/misc/doubleinit.cocci           |  2 +-
 scripts/coccinelle/misc/ifaddr.cocci               |  2 +-
 scripts/coccinelle/misc/ifcol.cocci                |  2 +-
 scripts/coccinelle/misc/noderef.cocci              |  2 +-
 scripts/coccinelle/misc/orplus.cocci               |  2 +-
 scripts/coccinelle/misc/warn.cocci                 |  2 +-
 scripts/coccinelle/null/eno.cocci                  |  2 +-
 scripts/coccinelle/null/kmerr.cocci                |  2 +-
 scripts/coccinelle/tests/doublebitand.cocci        |  2 +-
 scripts/coccinelle/tests/doubletest.cocci          |  2 +-
 scripts/coccinelle/tests/odd_ptr_err.cocci         |  2 +-
 37 files changed, 215 insertions(+), 75 deletions(-)
 create mode 100644 scripts/coccinelle/free/kfreeaddr.cocci
 create mode 100644 scripts/coccinelle/free/pci_free_consistent.cocci
