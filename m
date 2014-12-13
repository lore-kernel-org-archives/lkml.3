Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaLMRtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 12:49:41 -0500
Received: from 1wt.eu ([62.212.114.60]:62159 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaLMRtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 12:49:39 -0500
Date: Sat, 13 Dec 2014 18:49:39 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.32.65
Message-ID: <20141213174939.GA7338@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.32.65.

This version addresses the following list of security issues :
  CVE-2013-2147 (was incorrectly fixed in 2.6.32.61), CVE-2014-3184,
  CVE-2014-3185, CVE-2014-3687, CVE-2014-3688, CVE-2014-4653,
  CVE-2014-4654, CVE-2014-4655, CVE-2014-4943, CVE-2014-6410,
  CVE-2014-7841, CVE-2014-8709, CVE-2014-8884, CVE-2014-9090

and fixes various other bugs (see details below).

Special note: this version backports a new config entry CONFIG_X86_16BIT
which defaults to Y (compatibility mode). It makes it possible to disable
support for 16-bit applications (eg: dosemu/wine). Supporting such
applications requires a workaround known as "ESPFIX" for a processor bug,
which has been responsible for some of the last security issues affecting
2.6.32. Since the vast majority of users of 2.6.32 run it on servers
where 16-bit support is totally pointless, it is strongly recommended to
disable this option to stay safe and avoid upgrading again, should any
other bug in this area be discovered in the future.

The patch and changelog will appear soon at the following locations:
  https://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/
  https://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.65.xz
  https://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.65.gz
  https://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/ChangeLog-2.6.32.65

The updated 2.6.32.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
  http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y

The tree can be browsed on the gitweb interface:
  http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?h=linux-2.6.32.y

  Testing status (build/boot, OK/FAIL, otherwise not tested) :

         ARCH  |         CONFIGURATION
       --------+-----------------------------------
               |  allmodconfig     other-config
        x86_64 |    build:OK         boot:OK
          i386 |    build:OK           -

Thanks to all participants.
Willy

---------
 Documentation/x86/x86_64/mm.txt          |   2 +
 Makefile                                 |   2 +-
 arch/x86/Kconfig                         |  25 +++-
 arch/x86/include/asm/espfix.h            |  16 +++
 arch/x86/include/asm/irqflags.h          |   2 +-
 arch/x86/include/asm/page_32_types.h     |   1 -
 arch/x86/include/asm/page_64_types.h     |  11 +-
 arch/x86/include/asm/pgtable_64_types.h  |   2 +
 arch/x86/include/asm/setup.h             |   2 +
 arch/x86/include/asm/uaccess.h           |   1 -
 arch/x86/kernel/Makefile                 |   1 +
 arch/x86/kernel/dumpstack_64.c           |   1 -
 arch/x86/kernel/entry_32.S               |  17 ++-
 arch/x86/kernel/entry_64.S               |  98 +++++++++------
 arch/x86/kernel/espfix_64.c              | 208 +++++++++++++++++++++++++++++++
 arch/x86/kernel/ldt.c                    |   6 +
 arch/x86/kernel/paravirt_patch_64.c      |   2 -
 arch/x86/kernel/smpboot.c                |   7 ++
 arch/x86/kernel/traps.c                  |  67 ++++++++--
 arch/x86/mm/dump_pagetables.c            |  38 ++++--
 arch/x86/mm/extable.c                    |  31 -----
 block/blk-core.c                         |   4 +
 block/blk-exec.c                         |  15 ++-
 drivers/block/cciss.c                    |   2 +-
 drivers/connector/cn_proc.c              |   1 -
 drivers/md/raid5.c                       |   4 +-
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c |   3 +
 drivers/net/pppol2tp.c                   |   4 +-
 drivers/usb/serial/whiteheat.c           |   7 +-
 fs/udf/inode.c                           |  35 +++---
 include/net/sctp/sctp.h                  |   5 +
 init/main.c                              |   4 +
 net/8021q/vlan_dev.c                     |  10 +-
 net/compat.c                             |   2 +-
 net/mac80211/tx.c                        |   2 +-
 net/sctp/associola.c                     |   2 +
 net/sctp/inqueue.c                       |  33 ++---
 net/sctp/sm_make_chunk.c                 |   3 +
 net/sctp/sm_statefuns.c                  |   4 +-
 sound/core/control.c                     |  31 +++--
 40 files changed, 523 insertions(+), 188 deletions(-)

Summary of changes from 2.6.32.64 to 2.6.32.65
==============================================
Andy Lutomirski (4):
      x86_64/entry/xen: Do not invoke espfix64 on Xen
      x86_64, traps: Stop using IST for #SS
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Rework bad_iret

Ben Hutchings (4):
      sctp: Fix double-free introduced by bad backport in 2.6.32.62
      md/raid6: Fix misapplied backport in 2.6.32.64
      cciss: Fix misapplied "cciss: fix info leak in cciss_ioctl32_passthru()"
      proc connector: Delete spurious memset in proc_exit_connector()

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt page tables

Brian Gerst (1):
      x86, 64-bit: Move K8 B step iret fixup to fault entry asm

Dan Carpenter (1):
      ttusb-dec: buffer overflow in ioctl

Daniel Borkmann (3):
      net: sctp: fix panic on duplicate ASCONF chunks
      net: sctp: fix remote memory pressure from excessive queueing
      net: sctp: fix NULL pointer dereference in af->from_addr_param on malformed packet

H. Peter Anvin (7):
      x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
      x86-32, espfix: Remove filter for espfix32 due to race
      x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit stack
      x86, espfix: Move espfix definitions into a separate header file
      x86, espfix: Fix broken header guard
      x86, espfix: Make espfix64 a Kconfig option, fix UML
      x86, espfix: Make it possible to disable 16-bit support

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response

Jan Beulich (1):
      x86-64: Adjust frame type at paranoid_exit:

Jan Kara (1):
      udf: Avoid infinite loop when processing indirect ICBs

Johannes Berg (1):
      mac80211: fix fragmentation code, particularly for encryption

Lars-Peter Clausen (2):
      ALSA: control: Don't access controls outside of protected regions
      ALSA: control: Fix replacing user controls

Matthijs Kooijman (1):
      vlan: Don't propagate flag changes on down interfaces.

Muthukumar Ratty (1):
      block: Fix blk_execute_rq_nowait() dead queue handling

Sasha Levin (1):
      net/l2tp: don't fall back on UDP [get|set]sockopt

Tejun Heo (1):
      block: add missing blk_queue_dead() checks

Willy Tarreau (2):
      net: sendmsg: fix failed backport of "fix NULL pointer dereference"
      Linux 2.6.32.65

