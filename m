Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaHKPXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:23:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbaHKPXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:23:35 -0400
Date: Mon, 11 Aug 2014 17:23:32 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: himangi774@gmail.com, mmarek@suse.cz, shuah.kh@samsung.com,
        ydroneaud@opteya.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for 3.17-rc1
Message-ID: <20140811152332.GA4629@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the non-critical part of kbuild for 3.17-rc1:
- make help hint to use make -s with make kernelrelease et al.
- Moved a kbuild document to Documentation/kbuild where it belongs
- four new Coccinelle scripts, one dropped and one fixed
- new make kselftest target to run various tests on the kernel

Michal


The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

for you to fetch changes up to 5a5da78b3a48120d942c8a18ecc645f6acdf7da6:

  kbuild: kselftest - new make target to build and run kernel selftests (2014-08-07 22:30:01 +0200)

----------------------------------------------------------------
Himangi Saraogi (5):
      coccinelle/null: solve parse error
      Coccinelle: Script to detect cast after memory allocation
      Coccinelle: Script to use ARRAY_SIZE instead of division of two sizeofs
      Coccinelle: Script to detect incorrect argument to sizeof
      Coccinelle: Script to replace if and BUG with BUG_ON

Michal Marek (1):
      kbuild: make -s should be used with kernelrelease/kernelversion/image_name

Shuah Khan (1):
      kbuild: kselftest - new make target to build and run kernel selftests

Yann Droneaud (1):
      Documentation: headers_install.txt is part of kbuild

 Documentation/kbuild/00-INDEX                      |  2 +
 Documentation/{make => kbuild}/headers_install.txt |  0
 Makefile                                           | 18 ++++-
 scripts/coccinelle/api/alloc/alloc_cast.cocci      | 72 ++++++++++++++++++
 scripts/coccinelle/misc/array_size.cocci           | 87 ++++++++++++++++++++++
 scripts/coccinelle/misc/badty.cocci                | 76 +++++++++++++++++++
 .../drop_kmalloc_cast.cocci => misc/bugon.cocci}   | 47 ++++++------
 scripts/coccinelle/null/badzero.cocci              |  3 +-
 8 files changed, 275 insertions(+), 30 deletions(-)
 rename Documentation/{make => kbuild}/headers_install.txt (100%)
 create mode 100644 scripts/coccinelle/api/alloc/alloc_cast.cocci
 create mode 100644 scripts/coccinelle/misc/array_size.cocci
 create mode 100644 scripts/coccinelle/misc/badty.cocci
 rename scripts/coccinelle/{api/alloc/drop_kmalloc_cast.cocci => misc/bugon.cocci} (50%)
