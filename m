Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3KAIqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 04:46:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3KAIqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 04:46:10 -0400
Date: Fri, 1 Nov 2013 09:46:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 2/4] mm/rmap: convert anon_vma rwsem to rwlock_t
Message-ID: <20131101084605.GC19466@laptop.lan>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1383292467-28922-3-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383292467-28922-3-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 03:54:25PM +0800, Yuanhan Liu wrote:
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2955,15 +2955,15 @@ static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
>  		 * The LSB of head.next can't change from under us
>  		 * because we hold the mm_all_locks_mutex.
>  		 */
> -		down_write_nest_lock(&anon_vma->rwsem, &mm->mmap_sem);
> +		write_lock(&anon_vma->rwlock);

You lost:

  http://marc.info/?l=linux-kernel&m=138054148402109
