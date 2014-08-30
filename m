Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaH3QlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:41:19 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:62817 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaH3QlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:41:18 -0400
Subject: [PATCH v2 0/6] mm/balloon_compaction: fixes and cleanups
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Date: Sat, 30 Aug 2014 20:41:06 +0400
Message-ID: <20140830163834.29066.98205.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've checked compilation of linux-next/x86 for allnoconfig, defconfig and
defconfig + kvmconfig + virtio-balloon with and without balloon-compaction.
For stable kernels first three patches should be enough.

changes since v1:

mm/balloon_compaction: ignore anonymous pages
* no changes

mm/balloon_compaction: keep ballooned pages away from normal migration path
* fix compilation without CONFIG_BALLOON_COMPACTION

mm/balloon_compaction: isolate balloon pages without lru_lock
* no changes

mm: introduce common page state for ballooned memory
* move __Set/ClearPageBalloon into linux/mm.h
* remove inc/dec_zone_page_state from __Set/ClearPageBalloon

mm/balloon_compaction: use common page ballooning
* call inc/dec_zone_page_state from balloon_page_insert/delete

mm/balloon_compaction: general cleanup
* fix compilation without CONFIG_MIGRATION
* fix compilation without CONFIG_BALLOON_COMPACTION

---

Konstantin Khlebnikov (6):
      mm/balloon_compaction: ignore anonymous pages
      mm/balloon_compaction: keep ballooned pages away from normal migration path
      mm/balloon_compaction: isolate balloon pages without lru_lock
      mm: introduce common page state for ballooned memory
      mm/balloon_compaction: use common page ballooning
      mm/balloon_compaction: general cleanup


 Documentation/filesystems/proc.txt     |    2 
 drivers/base/node.c                    |   16 +-
 drivers/virtio/Kconfig                 |    1 
 drivers/virtio/virtio_balloon.c        |   77 +++--------
 fs/proc/meminfo.c                      |    6 +
 fs/proc/page.c                         |    3 
 include/linux/balloon_compaction.h     |  223 ++++++--------------------------
 include/linux/migrate.h                |   11 --
 include/linux/mm.h                     |   20 +++
 include/linux/mmzone.h                 |    3 
 include/linux/pagemap.h                |   18 ---
 include/uapi/linux/kernel-page-flags.h |    1 
 mm/Kconfig                             |    7 +
 mm/Makefile                            |    3 
 mm/balloon_compaction.c                |  219 ++++++++++---------------------
 mm/compaction.c                        |    9 +
 mm/migrate.c                           |   29 +---
 mm/vmscan.c                            |    2 
 mm/vmstat.c                            |    8 +
 tools/vm/page-types.c                  |    1 
 20 files changed, 210 insertions(+), 449 deletions(-)

--
Signature
