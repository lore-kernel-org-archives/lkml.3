Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaGBWh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:37:58 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:41555 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbaGBWh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:37:57 -0400
Date: Wed, 2 Jul 2014 18:37:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next] mm: memcontrol: rewrite charge API: fix
 shmem_unuse
Message-ID: <20140702223750.GA910@cmpxchg.org>
References: <alpine.LSU.2.11.1406301541420.4349@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1406301541420.4349@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 03:48:39PM -0700, Hugh Dickins wrote:
> Under shmem swapping and swapoff load, I sometimes hit the
> VM_BUG_ON_PAGE(!page->mapping) in mem_cgroup_commit_charge() at
> mm/memcontrol.c:6502!  Each time it has been a call from shmem_unuse().
> 
> Yes, there are some cases (most commonly when the page being unswapped
> is in a file being unlinked and evicted at that time) when the charge
> should not be committed.  In the old scheme, the page got uncharged
> again on release; but in the new scheme, it hits that BUG beforehand.
> 
> It's a useful BUG, so adapt shmem_unuse() to allow for it.  Which needs
> more info from shmem_unuse_inode(): so abuse -EAGAIN internally to
> replace the previous !found state (-ENOENT would be a more natural
> code, but that's exactly what you get when the swap has been evicted).
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks, Hugh!
