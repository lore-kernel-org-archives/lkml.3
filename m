Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaEUC1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:27:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaEUC1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:27:03 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH 0/4] pagecache scanning with /proc/kpagecache
Date: Tue, 20 May 2014 22:26:30 -0400
Message-Id: <1400639194-3743-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a new procfs interface to extrace information about
pagecache status. In-kernel tool tools/vm/page-types.c has already some
code for pagecache scanning without kernel's help, but it's not free
from measurement-disturbance, so here I'm suggesting another approach.

Patch 1/4 changes radix tree API to support ranged iteration as a preparation
for patch 2/4 which adds /proc/kpagecache. Patch 3/4 changes page-types to
use the interface in file scanning mode. Patch 4/4 is documentation update.

This patchset were previously posted as a part of memory error reporting
patchset (http://lwn.net/Articles/590690/), so changelogs in individual
patches are changes from that version.

Thanks,
Naoya Horiguchi
---
Summary:

Naoya Horiguchi (4):
      radix-tree: add end_index to support ranged iteration
      fs/proc/page.c: introduce /proc/kpagecache interface
      tools/vm/page-types.c: rework on file cache scanning mode
      Documentation: update Documentation/vm/pagemap.txt

 Documentation/vm/pagemap.txt  |  29 +++++
 drivers/gpu/drm/qxl/qxl_ttm.c |   2 +-
 fs/proc/page.c                | 105 ++++++++++++++++
 include/linux/fs.h            |   9 +-
 include/linux/radix-tree.h    |  27 +++--
 kernel/irq/irqdomain.c        |   2 +-
 lib/radix-tree.c              |   8 +-
 mm/filemap.c                  |   8 +-
 tools/vm/page-types.c         | 276 +++++++++++++++++-------------------------
 9 files changed, 284 insertions(+), 182 deletions(-)
