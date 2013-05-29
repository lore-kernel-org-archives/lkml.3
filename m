Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966355Ab3E2OpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:45:16 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57566 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966095Ab3E2OpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:45:14 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH, v2 00/13] kill free_all_bootmem_node() for all architectures
Date: Wed, 29 May 2013 22:44:39 +0800
Message-Id: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an effort to simplify arch mm initialization code by killing
free_all_bootmem_node().

It's applied on top of
	http://marc.info/?l=linux-mm&m=136983589203930&w=2

You may access the patch series at:
	git://github.com/jiangliu/linux.git mem_init_v6

Jiang Liu (13):
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
  mm/alpha: unify mem_init() for both UMA and NUMA architectures
  mm/m68k: fix build warning of unused variable

 arch/alpha/mm/init.c             |  7 ++-----
 arch/alpha/mm/numa.c             | 10 ----------
 arch/avr32/mm/init.c             | 21 +++++----------------
 arch/ia64/mm/init.c              |  9 ++-------
 arch/m32r/mm/init.c              | 17 ++++-------------
 arch/m68k/mm/init.c              | 15 ++++++++-------
 arch/metag/mm/init.c             | 14 ++------------
 arch/mips/sgi-ip27/ip27-memory.c | 12 +-----------
 arch/parisc/mm/init.c            | 12 +-----------
 arch/powerpc/mm/mem.c            | 16 +---------------
 arch/sh/mm/init.c                | 16 ++++------------
 include/linux/bootmem.h          |  1 -
 include/linux/mm.h               |  9 ++++++++-
 mm/bootmem.c                     | 18 ------------------
 14 files changed, 38 insertions(+), 139 deletions(-)

-- 
1.8.1.2

