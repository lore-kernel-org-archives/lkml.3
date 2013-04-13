Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3DMPkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:40:21 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43798 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3DMPkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:40:19 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 00/19] kill free_all_bootmem() and clean up VALID_PAGE()
Date: Sat, 13 Apr 2013 23:36:20 +0800
Message-Id: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 600cc5b7f6 "mm: Kill NO_BOOTMEM version free_all_bootmem_node()"
has kill free_all_bootmem_node() for NO_BOOTMEM.

Currently the usage pattern for free_all_bootmem_node() is like:
for_each_online_pgdat(pgdat)
	free_all_bootmem_node(pgdat);

It's equivalent to free_all_bootmem(), so this patchset goes one
step further to kill free_all_bootmem_node() for BOOTMEM too.

This patchset also tries to clean up code and comments related to
VALID_PAGE() because it has been removed from kernel long time ago.

Patch 1-11:
	Kill free_all_bootmem_node()
Patch 12-16:
	Clean up code and comments related to VALID_PAGE()
Patch 17:
	Fix a minor build warning for m68k
Patch 18:
	merge Alpha's mem_init() for UMA and NUMA.
Patch 19:
	call register_page_bootmem_info_node() from mm core

This patch is based on patchset at
http://marc.info/?l=linux-mm&m=136525931917910&w=2

Jiang Liu (19):
  mm: introduce accessor function set_max_mapnr()
  mm/AVR32: prepare for killing free_all_bootmem_node()
  mm/IA64: prepare for killing free_all_bootmem_node()
  mm/m32r: prepare for killing free_all_bootmem_node()
  mm/m68k: prepare for killing free_all_bootmem_node()
  mm/metag: prepare for killing free_all_bootmem_node()
  mm/MIPS: prepare for killing free_all_bootmem_node()
  mm/PARISC: prepare for killing free_all_bootmem_node()
  mm/PPC: prepare for killing free_all_bootmem_node()
  mm/SH: prepare for killing free_all_bootmem_node()
  mm: kill free_all_bootmem_node()
  mm/ALPHA: clean up unused VALID_PAGE()
  mm/CRIS: clean up unused VALID_PAGE()
  mm/microblaze: clean up unused VALID_PAGE()
  mm/ARM: fix stale comment about VALID_PAGE()
  mm/unicore32: fix stale comment about VALID_PAGE()
  mm/m68k: fix build warning of unused variable
  mm/alpha: unify mem_init() for both UMA and NUMA architectures
  mm: call register_page_bootmem_info_node() from mm core

 arch/alpha/include/asm/mmzone.h     |    2 --
 arch/alpha/mm/init.c                |    7 ++-----
 arch/alpha/mm/numa.c                |   10 ----------
 arch/arm/include/asm/memory.h       |    6 ------
 arch/avr32/mm/init.c                |   21 +++++----------------
 arch/cris/include/asm/page.h        |    1 -
 arch/ia64/mm/init.c                 |    9 ++-------
 arch/m32r/mm/init.c                 |   17 ++++-------------
 arch/m68k/mm/init.c                 |   15 ++++++++-------
 arch/metag/mm/init.c                |   14 ++------------
 arch/microblaze/include/asm/page.h  |    1 -
 arch/mips/sgi-ip27/ip27-memory.c    |   12 +-----------
 arch/parisc/mm/init.c               |   12 +-----------
 arch/powerpc/mm/mem.c               |   16 +---------------
 arch/sh/mm/init.c                   |   16 ++++------------
 arch/sparc/mm/init_64.c             |   12 ------------
 arch/unicore32/include/asm/memory.h |    6 ------
 arch/x86/mm/init_64.c               |   12 ------------
 include/linux/bootmem.h             |    1 -
 include/linux/mm.h                  |    9 ++++++++-
 mm/bootmem.c                        |   24 ++++++------------------
 mm/nobootmem.c                      |    6 ++++++
 22 files changed, 50 insertions(+), 179 deletions(-)

-- 
1.7.9.5

