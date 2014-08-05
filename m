Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbaHEIBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:01:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:33220 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbaHEIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:01:37 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/3] zram memory control enhance
Date: Tue,  5 Aug 2014 17:02:00 +0900
Message-Id: <1407225723-23754-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notice! It's RFC. I didn't test at all but wanted to hear opinion
during merge window when it's really busy time for Andrew so we could
use the slack time to discuss without hurting him. ;-)

Patch 1 is to move pages_allocated in zsmalloc from size_class to zs_pool
so zs_get_total_size_bytes of zsmalloc would be faster than old.
zs_get_total_size_bytes could be used next patches frequently.

Patch 2 adds new feature which exports how many of bytes zsmalloc consumes
during testing workload. Normally, before fixing the zram's disksize
we have tested various workload and wanted to how many of bytes zram
consumed.
For it, we could poll mem_used_total of zram in userspace but the problem is
when memory pressure is severe and heavy swap out happens suddenly then
heavy swapin or exist while polling interval of user space is a few second,
it could miss max memory size zram had consumed easily.
With lack of information, user can set wrong disksize of zram so the result
is OOM. So this patch adds max_mem_used for zram and zsmalloc supports it

Patch 3 is to limit zram memory consumption. Now, zram has no bound for
memory usage so it could consume up all of system memory. It makes system
memory control for platform hard so I have heard the feature several time.

Feedback is welcome!

Minchan Kim (3):
  zsmalloc: move pages_allocated to zs_pool
  zsmalloc/zram: add zs_get_max_size_bytes and use it in zram
  zram: limit memory size for zram

 Documentation/blockdev/zram.txt |  2 ++
 drivers/block/zram/zram_drv.c   | 58 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zram_drv.h   |  1 +
 include/linux/zsmalloc.h        |  1 +
 mm/zsmalloc.c                   | 50 +++++++++++++++++++++++++----------
 5 files changed, 98 insertions(+), 14 deletions(-)

-- 
2.0.0

