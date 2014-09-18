Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaIRSbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:31:32 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:65123 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbaIRSbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:31:31 -0400
Message-ID: <1411065089.2017.72.camel@x220>
Subject: [PATCH 0/5] MN10300: Remove dead code depending on DEPRECATED
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Sep 2014 20:31:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2014 18:31:29.0389 (UTC) FILETIME=[C352F1D0:01CFD36E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Raised before in
https://www.redhat.com/archives/linux-am33-list/2011-November/msg00007.html .

1) Discussed, at length, in https://lkml.org/lkml/2014/2/9/164 .

2) Compile tested only (on top of next-20140918, using
arch/mn10300/configs/asb2303_defconfig).

3) Logically this should be one humongous patch. It is split into five
patches to ease review. Review, or actually any reaction whatsoever,
would be appreciated.

4) The last patch was basically done by checking the output of
    git grep -i gdb.*stub arch/mn10300

and make educated guesses.

Paul Bolle (5):
  MN10300: Remove Kconfig symbol GDBSTUB
  MN10300: Remove Kconfig symbols depending on GDBSTUB
  MN10300: Remove all checks for CONFIG_GDBSTUB
  MN10300: Remove checks for GDBSTUB related Kconfig macros
  MN10300: Remove remnants of gdbstub

 arch/mn10300/Kconfig                            |    6 +-
 arch/mn10300/Kconfig.debug                      |  120 +-
 arch/mn10300/boot/compressed/misc.c             |    9 -
 arch/mn10300/include/asm/exceptions.h           |    7 -
 arch/mn10300/include/asm/gdb-stub.h             |  182 ---
 arch/mn10300/kernel/Makefile                    |    3 -
 arch/mn10300/kernel/entry.S                     |   21 -
 arch/mn10300/kernel/gdb-io-serial-low.S         |   91 --
 arch/mn10300/kernel/gdb-io-serial.c             |  174 --
 arch/mn10300/kernel/gdb-io-ttysm-low.S          |   93 --
 arch/mn10300/kernel/gdb-io-ttysm.c              |  303 ----
 arch/mn10300/kernel/gdb-low.S                   |  115 --
 arch/mn10300/kernel/gdb-stub.c                  | 1923 -----------------------
 arch/mn10300/kernel/head.S                      |   10 -
 arch/mn10300/kernel/mn10300-serial.c            |   28 +-
 arch/mn10300/kernel/mn10300-serial.h            |   15 -
 arch/mn10300/kernel/mn10300-watchdog.c          |   14 +-
 arch/mn10300/kernel/process.c                   |   11 -
 arch/mn10300/kernel/profile.c                   |    2 -
 arch/mn10300/kernel/smp-low.S                   |    4 -
 arch/mn10300/kernel/smp.c                       |    7 -
 arch/mn10300/kernel/traps.c                     |    4 +-
 arch/mn10300/mm/fault.c                         |    9 -
 arch/mn10300/mm/misalignment.c                  |    1 -
 arch/mn10300/mm/tlb-mn10300.S                   |   14 -
 arch/mn10300/unit-asb2303/include/unit/serial.h |   85 -
 arch/mn10300/unit-asb2303/unit-init.c           |    4 +-
 arch/mn10300/unit-asb2305/include/unit/serial.h |   78 -
 arch/mn10300/unit-asb2305/unit-init.c           |    6 +-
 arch/mn10300/unit-asb2364/include/unit/serial.h |   66 -
 arch/mn10300/unit-asb2364/unit-init.c           |    4 +-
 31 files changed, 16 insertions(+), 3393 deletions(-)
 delete mode 100644 arch/mn10300/include/asm/gdb-stub.h
 delete mode 100644 arch/mn10300/kernel/gdb-io-serial-low.S
 delete mode 100644 arch/mn10300/kernel/gdb-io-serial.c
 delete mode 100644 arch/mn10300/kernel/gdb-io-ttysm-low.S
 delete mode 100644 arch/mn10300/kernel/gdb-io-ttysm.c
 delete mode 100644 arch/mn10300/kernel/gdb-low.S
 delete mode 100644 arch/mn10300/kernel/gdb-stub.c

-- 
1.9.3

