Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3EARr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:47:26 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:39484 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3EARrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:47:18 -0400
Message-ID: <51815524.8010505@tilera.com>
Date: Wed, 1 May 2013 13:47:16 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile changes for v3.10
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.10 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These are some minor new feature work and other changes that didn't merit
getting pushed up after the 3.9 merge window closed.

There should be a lot more activity in the 3.11 merge window.

Chris Metcalf (2):
      tile: support atomic64_dec_if_positive()
      tile: comment assumption about __insn_mtspr for <asm/irqflags.h>

Henrik Austad (1):
      tile: ns2cycles should use __raw_get_cpu_var

Paul Bolle (2):
      tile: remove two outdated Kconfig entries
      arch: remove KCORE_ELF again [tile]

Simon Marchi (6):
      arch/tile: Call tracehook_report_syscall_{entry,exit} in syscall trace
      arch/tile: Enable HAVE_ARCH_TRACEHOOK
      tile: move declaration of sys_call_table to <asm/syscall.h>
      tile: Add definition of NR_syscalls
      tile: support TIF_SYSCALL_TRACEPOINT; select HAVE_SYSCALL_TRACEPOINTS
      arch/tile: Fix syscall return value passed to tracepoint

 arch/tile/Kconfig                   |   17 +++------------
 arch/tile/include/asm/atomic.h      |   21 +++++++++++++++++++
 arch/tile/include/asm/irqflags.h    |   10 ++++++++-
 arch/tile/include/asm/ptrace.h      |    3 ++-
 arch/tile/include/asm/syscall.h     |    6 ++++++
 arch/tile/include/asm/syscalls.h    |    6 ------
 arch/tile/include/asm/thread_info.h |    8 +++++++
 arch/tile/include/uapi/asm/unistd.h |    2 ++
 arch/tile/kernel/intvec_32.S        |   10 +++++++--
 arch/tile/kernel/intvec_64.S        |   24 +++++++++++++++------
 arch/tile/kernel/ptrace.c           |   39 ++++++++++++++++++-----------------
 arch/tile/kernel/time.c             |    6 +++++-
 12 files changed, 102 insertions(+), 50 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

