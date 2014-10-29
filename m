Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbaJ2QmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:42:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934051AbaJ2QmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:42:17 -0400
Date: Wed, 29 Oct 2014 17:41:36 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>
Subject: Re: [PATCH 2/4] mm: gup: add get_user_pages_locked and
 get_user_pages_unlocked
Message-ID: <20141029164136.GJ19606@redhat.com>
References: <1412153797-6667-1-git-send-email-aarcange@redhat.com>
 <1412153797-6667-3-git-send-email-aarcange@redhat.com>
 <20141009104723.GL4750@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009104723.GL4750@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 12:47:23PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 01, 2014 at 10:56:35AM +0200, Andrea Arcangeli wrote:
> > +static inline long __get_user_pages_locked(struct task_struct *tsk,
> > +					   struct mm_struct *mm,
> > +					   unsigned long start,
> > +					   unsigned long nr_pages,
> > +					   int write, int force,
> > +					   struct page **pages,
> > +					   struct vm_area_struct **vmas,
> > +					   int *locked,
> > +					   bool notify_drop)
> 
> You might want to consider __always_inline to make sure it does indeed
> get inlined and constant propagation works for @locked and @notify_drop.

Ok, that's included in the last patchset submit.

Thanks,
Andrea
