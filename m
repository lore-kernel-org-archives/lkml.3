Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaEIXnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 19:43:18 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:34618 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755200AbaEIXnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 19:43:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:960:968:973:988:989:1260:1345:1437:1534:1544:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3354:3866:3867:4605:5007:6261:6642:8957:10004:10026:10848:11026:11638:11658:11914:12043:12517:12519:12679:12683:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: club17_90cd83c54662e
X-Filterd-Recvd-Size: 4740
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 0/4] UserModeLinux: Message logging neatening
Date: Fri,  9 May 2014 16:43:09 -0700
Message-Id: <cover.1399678795.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (4):
  UserModeLinux: Convert UM_KERN_<LEVEL> to KERN_<LEVEL>
  UserModeLinux: Remove unused #defines of UM_KERN_<LEVEL>
  UserModeLinux: Use a more current logging style
  UserModeLinux: Convert printks to pr_<level>

 arch/um/drivers/chan_kern.c              |  27 +++----
 arch/um/drivers/chan_user.c              |  47 ++++++------
 arch/um/drivers/daemon_kern.c            |   8 +-
 arch/um/drivers/daemon_user.c            |  28 +++----
 arch/um/drivers/fd.c                     |   9 +--
 arch/um/drivers/harddog_kern.c           |   4 +-
 arch/um/drivers/harddog_user.c           |  14 ++--
 arch/um/drivers/hostaudio_kern.c         |  13 ++--
 arch/um/drivers/line.c                   |  24 +++---
 arch/um/drivers/mconsole_kern.c          |  29 +++----
 arch/um/drivers/mconsole_user.c          |   7 +-
 arch/um/drivers/mmapper_kern.c           |   7 +-
 arch/um/drivers/net_kern.c               |  53 +++++--------
 arch/um/drivers/net_user.c               |  20 ++---
 arch/um/drivers/pcap_kern.c              |   9 +--
 arch/um/drivers/pcap_user.c              |  19 +++--
 arch/um/drivers/port_kern.c              |  23 +++---
 arch/um/drivers/port_user.c              |   6 +-
 arch/um/drivers/pty.c                    |   4 +-
 arch/um/drivers/random.c                 |   3 +-
 arch/um/drivers/slip_kern.c              |   2 +-
 arch/um/drivers/slip_user.c              |  29 +++----
 arch/um/drivers/slirp_kern.c             |   9 +--
 arch/um/drivers/slirp_user.c             |   9 +--
 arch/um/drivers/ssl.c                    |  10 +--
 arch/um/drivers/stdio_console.c          |   9 +--
 arch/um/drivers/tty.c                    |   3 +-
 arch/um/drivers/ubd_kern.c               | 117 +++++++++++++----------------
 arch/um/drivers/ubd_user.c               |   6 +-
 arch/um/drivers/umcast_kern.c            |  38 +++++-----
 arch/um/drivers/umcast_user.c            |  35 ++++-----
 arch/um/drivers/vde_kern.c               |  23 +++---
 arch/um/drivers/vde_user.c               |  17 ++---
 arch/um/drivers/xterm.c                  |  26 +++----
 arch/um/drivers/xterm_kern.c             |   6 +-
 arch/um/include/asm/pgtable-2level.h     |  12 +--
 arch/um/include/asm/pgtable-3level.h     |  18 ++---
 arch/um/include/shared/user.h            |  12 +--
 arch/um/kernel/exec.c                    |   4 +-
 arch/um/kernel/exitcode.c                |   3 +-
 arch/um/kernel/initrd.c                  |  10 +--
 arch/um/kernel/irq.c                     |  14 ++--
 arch/um/kernel/physmem.c                 |  16 ++--
 arch/um/kernel/process.c                 |   2 +-
 arch/um/kernel/sigio.c                   |   4 +-
 arch/um/kernel/skas/mmu.c                |   9 +--
 arch/um/kernel/smp.c                     |  18 ++---
 arch/um/kernel/sysrq.c                   |  21 +++---
 arch/um/kernel/time.c                    |   6 +-
 arch/um/kernel/tlb.c                     |   8 +-
 arch/um/kernel/trap.c                    |   9 +--
 arch/um/os-Linux/aio.c                   |  45 +++++------
 arch/um/os-Linux/drivers/ethertap_kern.c |   8 +-
 arch/um/os-Linux/drivers/ethertap_user.c |  32 ++++----
 arch/um/os-Linux/drivers/tuntap_kern.c   |   6 +-
 arch/um/os-Linux/drivers/tuntap_user.c   |  24 +++---
 arch/um/os-Linux/file.c                  |  37 ++++-----
 arch/um/os-Linux/helper.c                |  33 ++++----
 arch/um/os-Linux/irq.c                   |   8 +-
 arch/um/os-Linux/process.c               |  31 ++++----
 arch/um/os-Linux/sigio.c                 |  83 +++++++++-----------
 arch/um/os-Linux/skas/mem.c              |  23 +++---
 arch/um/os-Linux/skas/process.c          | 125 ++++++++++++++-----------------
 arch/um/os-Linux/time.c                  |   3 +-
 arch/um/os-Linux/tty.c                   |  10 +--
 arch/um/os-Linux/umid.c                  |  48 ++++++------
 arch/x86/um/bugs_32.c                    |  14 ++--
 arch/x86/um/os-Linux/registers.c         |   2 +-
 68 files changed, 605 insertions(+), 786 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

