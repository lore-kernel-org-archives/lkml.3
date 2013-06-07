Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab3FGJy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:54:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30612 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab3FGJy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:54:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,821,1363104000"; 
   d="scan'208";a="7491513"
Message-ID: <51B1AD2F.4030702@cn.fujitsu.com>
Date: Fri, 07 Jun 2013 17:51:43 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: chanho.min@lge.com, Johannes Weiner <hannes@cmpxchg.org>,
        iamjoonsoo.kim@lge.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/3] mm, vmalloc: cleanup for vmap block
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 17:52:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 17:52:40,
	Serialize complete at 2013/06/07 17:52:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a cleanup for vmap block. And similar/same
patches has been submitted before:
- Johannes Weiner's patch: https://lkml.org/lkml/2011/4/14/619
- Chanho Min's patch: https://lkml.org/lkml/2013/2/6/810

In Johannes's thread, Mel suggested to figure out if this
bitmap was not supposed to be doing something useful and depending
on that implement recycling of partially used vmap blocks.

Anyway, just as Johannes said, we shouldn't leave these dead/unused
code as is, because it really is a waste of time for cpus and readers
of the code. And this cleanup doesn't prevent anyone from improving
the algorithm later on.

Based on the two patches before, I split the cleanup into three
small pieces that may be more clear.

Zhang Yanfei (3):
  mm, vmalloc: Remove dead code in vb_alloc
  mm, vmalloc: Remove unused purge_fragmented_blocks_thiscpu
  mm, vmalloc: Remove alloc_map from vmap_block

 mm/vmalloc.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)
