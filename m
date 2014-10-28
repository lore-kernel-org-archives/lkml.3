Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaJ1OL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:11:27 -0400
Received: from mta-out1.inet.fi ([62.71.2.194]:48268 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaJ1OLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:11:25 -0400
Date: Tue, 28 Oct 2014 16:08:29 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, hughd@google.com, riel@redhat.com,
        mgorman@suse.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, dbueso@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH 00/10] mm: improve usage of the i_mmap lock
Message-ID: <20141028140829.GA11524@node.dhcp.inet.fi>
References: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 03:06:10PM -0700, Davidlohr Bueso wrote:
> Davidlohr Bueso (10):
>   mm,fs: introduce helpers around the i_mmap_mutex
>   mm: use new helper functions around the i_mmap_mutex
>   mm: convert i_mmap_mutex to rwsem
>   mm/rmap: share the i_mmap_rwsem
>   uprobes: share the i_mmap_rwsem
>   mm/xip: share the i_mmap_rwsem
>   mm/memory-failure: share the i_mmap_rwsem
>   mm/mremap: share the i_mmap_rwsem
>   mm/nommu: share the i_mmap_rwsem
>   mm/hugetlb: share the i_mmap_rwsem
> 
>  fs/hugetlbfs/inode.c         | 14 +++++++-------
>  fs/inode.c                   |  2 +-
>  include/linux/fs.h           | 23 ++++++++++++++++++++++-
>  include/linux/mmu_notifier.h |  2 +-
>  kernel/events/uprobes.c      |  6 +++---
>  kernel/fork.c                |  4 ++--
>  mm/filemap.c                 | 10 +++++-----
>  mm/filemap_xip.c             | 23 +++++++++--------------
>  mm/fremap.c                  |  4 ++--
>  mm/hugetlb.c                 | 22 +++++++++++-----------
>  mm/memory-failure.c          |  4 ++--
>  mm/memory.c                  |  8 ++++----
>  mm/mmap.c                    | 22 +++++++++++-----------
>  mm/mremap.c                  |  6 +++---
>  mm/nommu.c                   | 17 ++++++++---------
>  mm/rmap.c                    | 12 ++++++------
>  16 files changed, 97 insertions(+), 82 deletions(-)

Apart from already mentioned cosmetics, the patchset looks good to me.

Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>

-- 
 Kirill A. Shutemov
