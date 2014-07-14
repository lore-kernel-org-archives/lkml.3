Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaGNPGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:06:25 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:43925 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbaGNPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:06:16 -0400
Date: Mon, 14 Jul 2014 17:06:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        David Howells <dhowells@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC PATCH 0/38] clean-up uapi + asm-generic Kbuild files
Message-ID: <20140714150609.GA28358@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working one another patch-set I noticed some stray Kbuild files.
And then when I started to dig into this it somehow got out
of control and I ended up with the following set of patches.

Almost 600 lines chopped of the kernel - which is nice.
But even better is that the Kbuild files for uapi + asm-generic
has become simpler to grok after the clean-up.

The patch-set contains the following major items:

o Fix headers_install for cris - this was trivial to fix
  after uapi support was added.

o Drop a few unused Kbuild files.

o Drop obsolete support for non uapi files in Makefile.headersinst

o Perform a long overdue clean-up of the uapi files.
 The files contained a lot of redundant assignments.

o The last patch introduces include/asm-generic/Kbuild.generic
  This file shall list all asm-generic files that are used by all architectures.
  This makes it much simpler to add a new common asm-generic file.

The patch was broken up in many smaller peices as I wanted to keep the clean-up
patches separate for each architecture to make it easier for arch maintainers to
review/ack their part.

The clean-up patches rely on one of the former patches so they shall
be applied as one serie.
It was done on top of -rc4.

What tree is the best for this stuff?
I would suggest to go via the asm-generic tree that Arnd has.
But it also touches a lot of architectures so Andrews -mm or
kbuild#misc could be used.

The patch-set touches all architectues so I could not copy
all arch maintainers on the mail. Thus I rely on them to read linux-arch.

	Sam


Sam Ravnborg (38):
      cris: fix headers_install
      openrisc: drop ucontext from list exported headers
      hexagon: drop ucontext from list exported headers
      score: drop irrelevant assignment from Kbuild file
      tile: clean up Kbuild files
      x86: clean-up Kbuild file - drop unused assignments
      Delete unused Kbuild files in include/*
      kbuild: drop support for non uapi Kbuild files in headers_install
      uapi: check for optional files which are generated
      uapi: drop obsolete logic for generated headers
      alpha: clean-up uapi Kbuild file
      arm: clean-up uapi Kbuild file
      arm64: clean-up uapi Kbuild file
      avr32: clean-up uapi Kbuild file
      blackfin: clean-up uapi Kbuild file
      c6x: clean-up uapi Kbuild file
      cris: clean-up uapi Kbuild file
      frv: clean-up uapi Kbuild file
      hexagon: clean-up uapi Kbuild file
      ia64: clean-up uapi Kbuild file
      m32r: clean-up uapi Kbuild file
      m68k: clean-up uapi Kbuild file
      metag: clean-up uapi Kbuild file
      microblaze: clean-up uapi Kbuild file
      mips: clean-up uapi Kbuild file
      mn10300: clean-up uapi Kbuild file
      openrisc: clean-up uapi Kbuild file
      parisc: clean-up uapi Kbuild file
      powerpc: clean-up uapi Kbuild file
      s390: clean-up uapi Kbuild file
      score: clean-up uapi Kbuild file
      sh: clean-up uapi Kbuild file
      sparc: clean-up uapi Kbuild file
      tile: clean-up uapi Kbuild file
      unicore32: clean-up uapi Kbuild file
      x86: clean-up uapi Kbuild file
      xtensa: clean-up uapi Kbuild file
      asm-generic: introduc Kbuild.generic

 Documentation/kbuild/makefiles.txt      |  4 ++--
 arch/alpha/include/asm/Kbuild           |  4 ++--
 arch/alpha/include/uapi/asm/Kbuild      | 32 ---------------------------
 arch/arc/include/asm/Kbuild             |  4 +++-
 arch/arm/include/asm/Kbuild             |  4 ++--
 arch/arm/include/uapi/asm/Kbuild        | 14 ------------
 arch/arm64/include/asm/Kbuild           |  4 ++--
 arch/arm64/include/uapi/asm/Kbuild      | 16 --------------
 arch/avr32/include/asm/Kbuild           |  3 ++-
 arch/avr32/include/uapi/asm/Kbuild      | 21 ++----------------
 arch/blackfin/include/asm/Kbuild        |  3 ++-
 arch/blackfin/include/uapi/asm/Kbuild   | 13 -----------
 arch/c6x/include/asm/Kbuild             |  3 ++-
 arch/c6x/include/uapi/asm/Kbuild        | 10 ---------
 arch/cris/include/asm/Kbuild            |  7 ++----
 arch/cris/include/uapi/asm/Kbuild       | 35 +++---------------------------
 arch/frv/include/asm/Kbuild             |  3 ++-
 arch/frv/include/uapi/asm/Kbuild        | 31 ---------------------------
 arch/hexagon/include/asm/Kbuild         |  5 ++---
 arch/hexagon/include/uapi/asm/Kbuild    | 10 ---------
 arch/ia64/include/asm/Kbuild            |  3 ++-
 arch/ia64/include/uapi/asm/Kbuild       | 36 +++----------------------------
 arch/m32r/include/asm/Kbuild            |  3 ++-
 arch/m32r/include/uapi/asm/Kbuild       | 31 ---------------------------
 arch/m68k/include/asm/Kbuild            |  4 +++-
 arch/m68k/include/uapi/asm/Kbuild       | 33 +++++++++-------------------
 arch/metag/include/asm/Kbuild           |  4 +++-
 arch/metag/include/uapi/asm/Kbuild      |  7 +-----
 arch/microblaze/include/asm/Kbuild      |  3 ++-
 arch/microblaze/include/uapi/asm/Kbuild | 34 +++--------------------------
 arch/mips/include/asm/Kbuild            |  5 +++--
 arch/mips/include/uapi/asm/Kbuild       | 38 ++++++---------------------------
 arch/mn10300/include/asm/Kbuild         |  3 ++-
 arch/mn10300/include/uapi/asm/Kbuild    | 32 ---------------------------
 arch/openrisc/include/asm/Kbuild        |  5 ++---
 arch/openrisc/include/uapi/asm/Kbuild   |  6 ------
 arch/parisc/include/asm/Kbuild          |  3 ++-
 arch/parisc/include/uapi/asm/Kbuild     | 30 +++-----------------------
 arch/powerpc/include/asm/Kbuild         |  3 ++-
 arch/powerpc/include/uapi/asm/Kbuild    | 32 ---------------------------
 arch/s390/include/asm/Kbuild            |  4 ++--
 arch/s390/include/uapi/asm/Kbuild       | 31 ---------------------------
 arch/score/include/asm/Kbuild           |  6 ++----
 arch/score/include/uapi/asm/Kbuild      | 32 ---------------------------
 arch/sh/include/asm/Kbuild              |  3 ++-
 arch/sh/include/uapi/asm/Kbuild         | 12 -----------
 arch/sparc/include/asm/Kbuild           |  5 ++---
 arch/sparc/include/uapi/asm/Kbuild      | 30 --------------------------
 arch/tile/include/arch/Kbuild           |  1 -
 arch/tile/include/asm/Kbuild            |  5 ++---
 arch/tile/include/uapi/asm/Kbuild       | 14 +-----------
 arch/um/include/asm/Kbuild              |  4 +++-
 arch/unicore32/include/asm/Kbuild       |  3 ++-
 arch/unicore32/include/uapi/asm/Kbuild  |  7 +-----
 arch/x86/include/asm/Kbuild             |  8 ++-----
 arch/x86/include/uapi/asm/Kbuild        | 34 +----------------------------
 arch/xtensa/include/asm/Kbuild          |  4 +++-
 arch/xtensa/include/uapi/asm/Kbuild     | 23 --------------------
 include/Kbuild                          |  2 --
 include/asm-generic/Kbuild.generic      |  6 ++++++
 include/scsi/fc/Kbuild                  |  0
 include/uapi/asm-generic/Kbuild.asm     |  2 +-
 include/video/Kbuild                    |  0
 scripts/Makefile.headersinst            | 22 ++-----------------
 scripts/headers.sh                      |  2 --
 65 files changed, 109 insertions(+), 692 deletions(-)
