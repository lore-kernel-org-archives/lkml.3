Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaHES3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:29:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaHES3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:29:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/19] 3.4.102-stable review
Date: Tue,  5 Aug 2014 11:29:24 -0700
Message-Id: <20140805182934.022406678@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.102 release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Aug  7 18:29:24 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.102-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.102-rc1

Gao feng <gaofeng@cn.fujitsu.com>
    ipv6: reallocate addrconf router for ipv6 address when lo device up

Vlastimil Babka <vbabka@suse.cz>
    mm: try_to_unmap_cluster() should lock_page() before mlocking

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/espfix/xen: Fix allocation of pages for paravirt page tables

Minfei Huang <huangminfei@ucloud.cn>
    lib/btree.c: fix leak of whole btree nodes

Sasha Levin <sasha.levin@oracle.com>
    net/l2tp: don't fall back on UDP [get|set]sockopt

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert: "net: ip, ipv6: handle gso skbs in forwarding path"

Andy Lutomirski <luto@amacapital.net>
    x86_64/entry/xen: Do not invoke espfix64 on Xen

H. Peter Anvin <hpa@zytor.com>
    x86, espfix: Make it possible to disable 16-bit support

H. Peter Anvin <hpa@zytor.com>
    x86, espfix: Make espfix64 a Kconfig option, fix UML

H. Peter Anvin <hpa@linux.intel.com>
    x86, espfix: Fix broken header guard

H. Peter Anvin <hpa@linux.intel.com>
    x86, espfix: Move espfix definitions into a separate header file

H. Peter Anvin <hpa@linux.intel.com>
    x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit stack

H. Peter Anvin <hpa@zytor.com>
    Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtime option"

Jan Kara <jack@suse.cz>
    timer: Fix lock inversion between hrtimer_bases.lock and scheduler locks

John Stultz <john.stultz@linaro.org>
    printk: rename printk_sched to printk_deferred

David Rientjes <rientjes@google.com>
    mm, thp: do not allow thp faults to avoid cpuset restrictions

James Bottomley <JBottomley@Parallels.com>
    scsi: handle flush errors properly

Konstantin Khlebnikov <k.khlebnikov@samsung.com>
    ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual memory layout

Milan Broz <gmazyland@gmail.com>
    crypto: af_alg - properly label AF_ALG socket


-------------

Diffstat:

 Documentation/x86/x86_64/mm.txt         |   2 +
 Makefile                                |   4 +-
 arch/arm/mm/idmap.c                     |   7 ++
 arch/x86/Kconfig                        |  25 +++-
 arch/x86/include/asm/espfix.h           |  16 +++
 arch/x86/include/asm/irqflags.h         |   2 +-
 arch/x86/include/asm/pgtable_64_types.h |   2 +
 arch/x86/include/asm/setup.h            |   2 +
 arch/x86/kernel/Makefile                |   1 +
 arch/x86/kernel/entry_32.S              |  12 ++
 arch/x86/kernel/entry_64.S              |  80 ++++++++++--
 arch/x86/kernel/espfix_64.c             | 208 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/ldt.c                   |  10 +-
 arch/x86/kernel/paravirt_patch_64.c     |   2 -
 arch/x86/kernel/smpboot.c               |   7 ++
 arch/x86/mm/dump_pagetables.c           |  31 +++--
 arch/x86/vdso/vdso32-setup.c            |   8 --
 crypto/af_alg.c                         |   2 +
 drivers/scsi/scsi_lib.c                 |   8 ++
 include/linux/printk.h                  |   6 +-
 include/linux/skbuff.h                  |  17 ---
 init/main.c                             |   4 +
 kernel/printk.c                         |   2 +-
 kernel/sched/core.c                     |   2 +-
 kernel/sched/rt.c                       |   2 +-
 kernel/time/clockevents.c               |  10 +-
 lib/btree.c                             |   1 +
 mm/mlock.c                              |   2 +
 mm/page_alloc.c                         |  16 +--
 mm/rmap.c                               |  14 ++-
 net/ipv4/ip_forward.c                   |  68 +----------
 net/ipv6/addrconf.c                     |  14 ++-
 net/ipv6/ip6_output.c                   |  13 +-
 net/l2tp/l2tp_ppp.c                     |   4 +-
 34 files changed, 439 insertions(+), 165 deletions(-)


