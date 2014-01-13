Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaAMLhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:37:47 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:59654 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaAMLho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:37:44 -0500
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, qiuxishi@huawei.com, dhowells@redhat.com,
        daeseok.youn@gmail.com, liuj97@gmail.com, yinghai@kernel.org,
        phacht@linux.vnet.ibm.com, zhangyanfei@cn.fujitsu.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        tangchen@cn.fujitsu.com, schwidefsky@de.ibm.com
Subject: [PATCH 0/2] mm/memblock: Excluded memory, free_all_bootmem
Date: Mon, 13 Jan 2014 12:37:12 +0100
Message-Id: <1389613034-35196-1-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011311-1948-0000-0000-000007749697
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fit (only) on top of linux-next!

The first patch changes back the behavior of free_all_bootmem() to
a more generic way: With CONFIG_DISCARD_MEMBLOCK memblock.memory
and memblock.reserved will be freed (if allocated, of course).
Removed the debugfs dependency. Think this is cleaner.

While further working on the s390 migration to memblock it is desirable
to have memblock support unmapped (i.e. completely forgotten and unused)
memory areas. The usual way of just forgetting about them by means of
truncating the memblocks does not work for us because we still need the
information about the real full memory structure at a later time.


Philipp Hachtmann (2):
  mm/nobootmem: free_all_bootmem again
  mm/memblock: Add support for excluded memory areas

 include/linux/memblock.h |  50 ++++++--
 mm/memblock.c            | 324 +++++++++++++++++++++++++++++++----------------
 mm/nobootmem.c           |  13 +-
 3 files changed, 271 insertions(+), 116 deletions(-)

-- 
1.8.4.5

