Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3JHL2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:28:54 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754649Ab3JHL2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:28:52 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk, vgupta@synopsys.com,
        catalin.marinas@arm.com, will.deacon@arm.com, hskinnemoen@gmail.com,
        egtvedt@samfundet.no, vapier@gentoo.org, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, rkuo@codeaurora.org, tony.luck@intel.com,
        fenghua.yu@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu,
        yasutake.koichi@jp.panasonic.com, ralf@linux-mips.org,
        jonas@southpole.se, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com,
        lethal@linux-sh.org, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org
Subject: Global do_signal() cleanup
Date: Tue,  8 Oct 2013 13:27:52 +0200
Message-Id: <1381231701-4008-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series moves all remaining archs to the get_signal() and
signal_setup_done() functions. Currently these archs use open coded
variants of the said functions.  Further, unused parameters get removed
from get_signal_to_deliver(), tracehook_signal_handler() and signal_delivered().
After all we save around 350 lines of code. :-)

The following archs are _untested_: arc, c6x, hexagon, metag, score, unicore, sh64.
If someone points me to cross compilers for these arch I'll happily build test them too.

Thanks,
//richard

[PATCH 01/29] arc: Use get_signal() signal_setup_done()
[PATCH 02/29] arm64: Use get_signal() signal_setup_done()
[PATCH 03/29] avr32: Use get_signal() signal_setup_done()
[PATCH 04/29] blackfin: Use get_signal() signal_setup_done()
[PATCH 05/29] c6x: Use get_signal() signal_setup_done()
[PATCH 06/29] cris: Use get_signal() signal_setup_done()
[PATCH 07/29] frv: Use get_signal() signal_setup_done()
[PATCH 08/29] h8300: Use get_signal() signal_setup_done()
[PATCH 09/29] hexagon: Use get_signal() signal_setup_done()
[PATCH 10/29] ia64: Use get_signal() signal_setup_done()
[PATCH 11/29] m32r: Use get_signal() signal_setup_done()
[PATCH 12/29] m68k: Use get_signal() signal_setup_done()
[PATCH 13/29] metag: Use get_signal() signal_setup_done()
[PATCH 14/29] microblaze: Use get_signal() signal_setup_done()
[PATCH 15/29] mips: Use get_signal() signal_setup_done()
[PATCH 16/29] mn10300: Use get_signal() signal_setup_done()
[PATCH 17/29] openrisc: Use get_signal() signal_setup_done()
[PATCH 18/29] parisc: Use get_signal() signal_setup_done()
[PATCH 19/29] powerpc: Use get_signal() signal_setup_done()
[PATCH 20/29] s390: Use get_signal() signal_setup_done()
[PATCH 21/29] score: Use get_signal() signal_setup_done()
[PATCH 22/29] sh: Use get_signal() signal_setup_done()
[PATCH 23/29] tile: Use get_signal() signal_setup_done()
[PATCH 24/29] um: Use get_signal() signal_setup_done()
[PATCH 25/29] unicore32: Use get_signal() signal_setup_done()
[PATCH 26/29] xtensa: Use get_signal() signal_setup_done()
[PATCH 27/29] get_signal_to_deliver: remove regs and cookie args
[PATCH 28/29] tracehook_signal_handler: Remove sig, info, ka and regs
[PATCH 29/29] Clean up signal_delivered()

 arch/arc/kernel/signal.c            |   39 +++++---------
 arch/arm64/include/asm/signal32.h   |    7 +-
 arch/arm64/kernel/signal.c          |   48 +++++++----------
 arch/arm64/kernel/signal32.c        |    8 +-
 arch/avr32/kernel/signal.c          |   43 ++++++---------
 arch/blackfin/kernel/signal.c       |   39 ++++++--------
 arch/c6x/kernel/signal.c            |   43 ++++++---------
 arch/cris/arch-v10/kernel/signal.c  |   79 ++++++++++++----------------
 arch/cris/arch-v32/kernel/signal.c  |   77 ++++++++++------------------
 arch/frv/kernel/signal.c            |   99 ++++++++++++++----------------------
 arch/h8300/kernel/signal.c          |   81 ++++++++++++-----------------
 arch/hexagon/kernel/signal.c        |   45 ++++++----------
 arch/ia64/kernel/signal.c           |   42 ++++++---------
 arch/m32r/kernel/signal.c           |   47 +++++++----------
 arch/m68k/kernel/signal.c           |   63 ++++++++--------------
 arch/metag/kernel/signal.c          |   55 ++++++++------------
 arch/microblaze/kernel/signal.c     |   48 ++++++-----------
 arch/mips/include/asm/abi.h         |   10 +--
 arch/mips/kernel/signal.c           |   66 +++++++++---------------
 arch/mips/kernel/signal32.c         |   39 +++++---------
 arch/mips/kernel/signal_n32.c       |   20 ++-----
 arch/mn10300/kernel/signal.c        |   89 +++++++++++++-------------------
 arch/openrisc/kernel/signal.c       |   53 +++++++------------
 arch/parisc/kernel/signal.c         |   58 ++++++++-------------
 arch/powerpc/kernel/signal.c        |   31 ++++-------
 arch/powerpc/kernel/signal.h        |   12 +---
 arch/powerpc/kernel/signal_32.c     |   38 +++++--------
 arch/powerpc/kernel/signal_64.c     |   27 ++++-----
 arch/s390/kernel/compat_signal.c    |   77 ++++++++++++----------------
 arch/s390/kernel/entry.h            |    4 -
 arch/s390/kernel/signal.c           |   79 +++++++++++-----------------
 arch/score/kernel/signal.c          |   43 ++++++---------
 arch/sh/kernel/signal_32.c          |   79 +++++++++++-----------------
 arch/sh/kernel/signal_64.c          |   82 +++++++++++------------------
 arch/tile/include/asm/compat.h      |    3 -
 arch/tile/kernel/compat_signal.c    |   29 +++++-----
 arch/tile/kernel/signal.c           |   54 ++++++++-----------
 arch/um/include/shared/frame_kern.h |   12 +---
 arch/um/kernel/signal.c             |   27 ++++-----
 arch/unicore32/kernel/signal.c      |   48 +++++++----------
 arch/x86/um/signal.c                |   45 +++++++---------
 arch/xtensa/kernel/signal.c         |   43 +++++----------
 include/linux/signal.h              |    6 --
 include/linux/tracehook.h           |    8 --
 kernel/signal.c                     |   26 +++------
 45 files changed, 804 insertions(+), 1167 deletions(-)

