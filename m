Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaENTxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:53:03 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750750AbaENTxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:53:00 -0400
Message-ID: <5373C996.7000409@nod.at>
Date: Wed, 14 May 2014 21:52:54 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
CC: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/4] UserModeLinux: Message logging neatening
References: <cover.1399678795.git.joe@perches.com>
In-Reply-To: <cover.1399678795.git.joe@perches.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.05.2014 01:43, schrieb Joe Perches:
> Joe Perches (4):
>   UserModeLinux: Convert UM_KERN_<LEVEL> to KERN_<LEVEL>
>   UserModeLinux: Remove unused #defines of UM_KERN_<LEVEL>
>   UserModeLinux: Use a more current logging style
>   UserModeLinux: Convert printks to pr_<level>
> 
>  arch/um/drivers/chan_kern.c              |  27 +++----
>  arch/um/drivers/chan_user.c              |  47 ++++++------
>  arch/um/drivers/daemon_kern.c            |   8 +-
>  arch/um/drivers/daemon_user.c            |  28 +++----
>  arch/um/drivers/fd.c                     |   9 +--
>  arch/um/drivers/harddog_kern.c           |   4 +-
>  arch/um/drivers/harddog_user.c           |  14 ++--
>  arch/um/drivers/hostaudio_kern.c         |  13 ++--
>  arch/um/drivers/line.c                   |  24 +++---
>  arch/um/drivers/mconsole_kern.c          |  29 +++----
>  arch/um/drivers/mconsole_user.c          |   7 +-
>  arch/um/drivers/mmapper_kern.c           |   7 +-
>  arch/um/drivers/net_kern.c               |  53 +++++--------
>  arch/um/drivers/net_user.c               |  20 ++---
>  arch/um/drivers/pcap_kern.c              |   9 +--
>  arch/um/drivers/pcap_user.c              |  19 +++--
>  arch/um/drivers/port_kern.c              |  23 +++---
>  arch/um/drivers/port_user.c              |   6 +-
>  arch/um/drivers/pty.c                    |   4 +-
>  arch/um/drivers/random.c                 |   3 +-
>  arch/um/drivers/slip_kern.c              |   2 +-
>  arch/um/drivers/slip_user.c              |  29 +++----
>  arch/um/drivers/slirp_kern.c             |   9 +--
>  arch/um/drivers/slirp_user.c             |   9 +--
>  arch/um/drivers/ssl.c                    |  10 +--
>  arch/um/drivers/stdio_console.c          |   9 +--
>  arch/um/drivers/tty.c                    |   3 +-
>  arch/um/drivers/ubd_kern.c               | 117 +++++++++++++----------------
>  arch/um/drivers/ubd_user.c               |   6 +-
>  arch/um/drivers/umcast_kern.c            |  38 +++++-----
>  arch/um/drivers/umcast_user.c            |  35 ++++-----
>  arch/um/drivers/vde_kern.c               |  23 +++---
>  arch/um/drivers/vde_user.c               |  17 ++---
>  arch/um/drivers/xterm.c                  |  26 +++----
>  arch/um/drivers/xterm_kern.c             |   6 +-
>  arch/um/include/asm/pgtable-2level.h     |  12 +--
>  arch/um/include/asm/pgtable-3level.h     |  18 ++---
>  arch/um/include/shared/user.h            |  12 +--
>  arch/um/kernel/exec.c                    |   4 +-
>  arch/um/kernel/exitcode.c                |   3 +-
>  arch/um/kernel/initrd.c                  |  10 +--
>  arch/um/kernel/irq.c                     |  14 ++--
>  arch/um/kernel/physmem.c                 |  16 ++--
>  arch/um/kernel/process.c                 |   2 +-
>  arch/um/kernel/sigio.c                   |   4 +-
>  arch/um/kernel/skas/mmu.c                |   9 +--
>  arch/um/kernel/smp.c                     |  18 ++---
>  arch/um/kernel/sysrq.c                   |  21 +++---
>  arch/um/kernel/time.c                    |   6 +-
>  arch/um/kernel/tlb.c                     |   8 +-
>  arch/um/kernel/trap.c                    |   9 +--
>  arch/um/os-Linux/aio.c                   |  45 +++++------
>  arch/um/os-Linux/drivers/ethertap_kern.c |   8 +-
>  arch/um/os-Linux/drivers/ethertap_user.c |  32 ++++----
>  arch/um/os-Linux/drivers/tuntap_kern.c   |   6 +-
>  arch/um/os-Linux/drivers/tuntap_user.c   |  24 +++---
>  arch/um/os-Linux/file.c                  |  37 ++++-----
>  arch/um/os-Linux/helper.c                |  33 ++++----
>  arch/um/os-Linux/irq.c                   |   8 +-
>  arch/um/os-Linux/process.c               |  31 ++++----
>  arch/um/os-Linux/sigio.c                 |  83 +++++++++-----------
>  arch/um/os-Linux/skas/mem.c              |  23 +++---
>  arch/um/os-Linux/skas/process.c          | 125 ++++++++++++++-----------------
>  arch/um/os-Linux/time.c                  |   3 +-
>  arch/um/os-Linux/tty.c                   |  10 +--
>  arch/um/os-Linux/umid.c                  |  48 ++++++------
>  arch/x86/um/bugs_32.c                    |  14 ++--
>  arch/x86/um/os-Linux/registers.c         |   2 +-
>  68 files changed, 605 insertions(+), 786 deletions(-)
> 

Thank you Joe!
I'll queue your patches for 3.16.

Thanks,
//richard
