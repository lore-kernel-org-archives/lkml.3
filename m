Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3JBUSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:18:04 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:47443 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3JBUSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:18:02 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 0/2] fs,mm: abstract i_mmap_mutex lock
Date: Wed,  2 Oct 2013 13:17:44 -0700
Message-Id: <1380745066-9925-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In lure of the sleepable-vs-non-sleepable anon-vma/i_mmap locking
discussion, this patchset encapsulates the i_mmap_mutex lock into
two functions to lock and unlock (for writting). This is very similar
to how we currently deal with anon-vma lock, making it a lot easier to 
change the lock type.

I've split these changes in to two patches since it makes patch 2 nicer
to review, matching additions with deletions. 

Thanks!

Davidlohr Bueso (2):
  mm,fs: introduce helpers around i_mmap_mutex
  fs,mm: use new helper functions around the i_mmap_mutex

 fs/hugetlbfs/inode.c    |  4 ++--
 include/linux/fs.h      | 10 ++++++++++
 kernel/events/uprobes.c |  4 ++--
 kernel/fork.c           |  4 ++--
 mm/filemap_xip.c        |  4 ++--
 mm/fremap.c             |  4 ++--
 mm/hugetlb.c            | 12 ++++++------
 mm/memory-failure.c     |  4 ++--
 mm/memory.c             |  8 ++++----
 mm/mmap.c               | 14 +++++++-------
 mm/mremap.c             |  4 ++--
 mm/nommu.c              | 14 +++++++-------
 mm/rmap.c               | 16 ++++++++--------
 13 files changed, 56 insertions(+), 46 deletions(-)

-- 
1.8.1.4

