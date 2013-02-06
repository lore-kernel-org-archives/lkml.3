Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3BFFNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:13:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6547 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3BFFNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:13:24 -0500
X-IronPort-AV: E=Sophos;i="4.84,613,1355068800"; 
   d="scan'208";a="6694824"
Message-ID: <5111E612.4010907@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 13:11:46 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] mm: fix types for some functions and variables in case
 of overflow
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 13:12:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 13:12:03,
	Serialize complete at 2013/02/06 13:12:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the amount of RAM that functions nr_free_*_pages return
is held in unsigned int. But in machines with big memory (exceeding
16TB), the amount may be incorrect because of overflow, so fix this
problem.

Also, fix the types of variables that is related to nr_free_*_pages.
For these variables are placed in several subsystems, I may be incorrectly
fix them, if there is any problem with the fix, please correct me.

Zhang Yanfei (7):
  mm: fix return type for functions nr_free_*_pages
  ia64: use %ld to print pages calculated in nr_free_buffer_pages
  fs/buffer.c: change type of max_buffer_heads to unsigned long
  fs/nfsd: change type of max_delegations, nfsd_drc_max_mem and
    nfsd_drc_mem_used
  vmscan: change type of vm_total_pages to unsigned long
  net: change type of netns_ipvs->sysctl_sync_qlen_max
  net: change type of virtio_chan->p9_max_pages

 arch/ia64/mm/contig.c    |    2 +-
 arch/ia64/mm/discontig.c |    2 +-
 fs/buffer.c              |    4 ++--
 fs/nfsd/nfs4state.c      |    6 +++---
 fs/nfsd/nfsd.h           |    6 +++---
 fs/nfsd/nfssvc.c         |    6 +++---
 include/linux/swap.h     |    6 +++---
 include/net/ip_vs.h      |    2 +-
 mm/page_alloc.c          |    8 ++++----
 mm/vmscan.c              |    2 +-
 net/9p/trans_virtio.c    |    2 +-
 11 files changed, 23 insertions(+), 23 deletions(-)

