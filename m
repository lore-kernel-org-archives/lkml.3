Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3BERKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:10:09 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:50769 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3BERKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:10:06 -0500
Message-ID: <51113CE3.5090000@gmail.com>
Date: Wed, 06 Feb 2013 01:09:55 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: akpm@linux-foundation.org, Linux MM <linux-mm@kvack.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        m.szyprowski@samsung.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] mm: rename confusing function names
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function nr_free_zone_pages, nr_free_buffer_pages and nr_free_pagecache_pages
are horribly badly named, they count present_pages - pages_high within zones
instead of free pages, so why not rename them to reasonable names, not cofusing
people.

patch2 and patch3 are based on patch1. So please apply patch1 first.

Zhang Yanfei (3):
  mm: rename nr_free_zone_pages to nr_free_zone_high_pages
  mm: rename nr_free_buffer_pages to nr_free_buffer_high_pages
  mm: rename nr_free_pagecache_pages to nr_free_pagecache_high_pages

 arch/ia64/mm/contig.c          |    3 ++-
 arch/ia64/mm/discontig.c       |    3 ++-
 drivers/mmc/card/mmc_test.c    |    4 ++--
 fs/buffer.c                    |    2 +-
 fs/nfsd/nfs4state.c            |    2 +-
 fs/nfsd/nfssvc.c               |    2 +-
 include/linux/swap.h           |    4 ++--
 mm/huge_memory.c               |    2 +-
 mm/memory_hotplug.c            |    4 ++--
 mm/page-writeback.c            |    2 +-
 mm/page_alloc.c                |   22 ++++++++++++----------
 net/9p/trans_virtio.c          |    2 +-
 net/ipv4/tcp.c                 |    4 ++--
 net/ipv4/udp.c                 |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c |    2 +-
 net/sctp/protocol.c            |    2 +-
 16 files changed, 33 insertions(+), 29 deletions(-)
