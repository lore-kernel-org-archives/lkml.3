Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaLFSBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:01:33 -0500
Received: from 1wt.eu ([62.212.114.60]:40680 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbaLFRyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:47 -0500
Message-Id: <20141206174148.394089034@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:41:48 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 00/25] 2.6.32.65-longterm review
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.65 release.
All patches will be posted as a response to this one. If anyone has any
issue with these being applied, please let me know. If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by: line
to the patch, please respond with it.

Responses should be made by Fri Dec 12 12:00:00 CET 2014.
Anything received after that time might be too late. If someone
wants a bit more time for a deeper review, please let me know.

The whole patch series can be found in one patch at :
     kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.65-rc1.gz

The shortlog and diffstat are appended below.

Thanks,
Willy

===============

Andy Lutomirski (4):
      x86_64/entry/xen: Do not invoke espfix64 on Xen
      x86_64, traps: Stop using IST for #SS
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Rework bad_iret

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

Sasha Levin (1):
      net/l2tp: don't fall back on UDP [get|set]sockopt

Willy Tarreau (1):
      net: sendmsg: fix failed backport of "fix NULL pointer dereference"

 Documentation/x86/x86_64/mm.txt          |  2 +
 arch/x86/Kconfig                         | 25 ++++++--
 arch/x86/include/asm/irqflags.h          |  2 +-
 arch/x86/include/asm/page_32_types.h     |  1 -
 arch/x86/include/asm/page_64_types.h     | 11 ++--
 arch/x86/include/asm/pgtable_64_types.h  |  2 +
 arch/x86/include/asm/setup.h             |  2 +
 arch/x86/include/asm/uaccess.h           |  1 -
 arch/x86/kernel/Makefile                 |  1 +
 arch/x86/kernel/dumpstack_64.c           |  1 -
 arch/x86/kernel/entry_32.S               | 17 ++++--
 arch/x86/kernel/entry_64.S               | 98 ++++++++++++++++++++------------
 arch/x86/kernel/ldt.c                    |  6 ++
 arch/x86/kernel/paravirt_patch_64.c      |  2 -
 arch/x86/kernel/smpboot.c                |  7 +++
 arch/x86/kernel/traps.c                  | 67 +++++++++++++++++-----
 arch/x86/mm/dump_pagetables.c            | 38 +++++++++----
 arch/x86/mm/extable.c                    | 31 ----------
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c |  3 +
 drivers/net/pppol2tp.c                   |  4 +-
 drivers/usb/serial/whiteheat.c           |  7 ++-
 fs/udf/inode.c                           | 35 +++++++-----
 include/net/sctp/sctp.h                  |  5 ++
 init/main.c                              |  4 ++
 net/compat.c                             |  2 +-
 net/mac80211/tx.c                        |  2 +-
 net/sctp/associola.c                     |  2 +
 net/sctp/inqueue.c                       | 33 +++--------
 net/sctp/sm_make_chunk.c                 |  3 +
 net/sctp/sm_statefuns.c                  |  3 +
 sound/core/control.c                     | 31 +++++-----
 31 files changed, 274 insertions(+), 174 deletions(-)
--



