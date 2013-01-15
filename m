Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3AOKzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:55:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32090 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756199Ab3AOKzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:55:40 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355068800"; 
   d="scan'208";a="6591338"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, glommer@parallels.com, jiang.liu@huawei.com
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: [BUG Fix Patch 0/6] Bug fix for physical memory hot-remove.
Date: Tue, 15 Jan 2013 18:54:21 +0800
Message-Id: <1358247267-18089-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:54:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:54:29,
	Serialize complete at 2013/01/15 18:54:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are some bug fix patches for physical hot-remove patches.
And there are some new ones reported by others, I'll fix them soon.

Thanks. :)


Tang Chen (6):
  Bug fix: Hold spinlock across find|remove /sys/firmware/memmap/X
    operation.
  Bug fix: Do not calculate direct mapping pages when freeing vmemmap
    pagetables.
  Bug fix: Do not free direct mapping pages twice.
  Bug fix: Do not free page split from hugepage one by one.
  Bug fix: Fix the wrong comments of map_entries.
  Bug fix: Reuse the storage of /sys/firmware/memmap/X/ allocated by
    bootmem.

 arch/x86/mm/init_64.c     |   92 ++++++++++++++++++++++++++++-----
 drivers/firmware/memmap.c |  124 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 179 insertions(+), 37 deletions(-)

