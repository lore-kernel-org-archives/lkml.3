Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaJIKrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:47:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:39075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbaJIKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:47:30 -0400
Date: Thu, 9 Oct 2014 12:47:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
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
Message-ID: <20141009104723.GL4750@worktop.programming.kicks-ass.net>
References: <1412153797-6667-1-git-send-email-aarcange@redhat.com>
 <1412153797-6667-3-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412153797-6667-3-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:56:35AM +0200, Andrea Arcangeli wrote:
> +static inline long __get_user_pages_locked(struct task_struct *tsk,
> +					   struct mm_struct *mm,
> +					   unsigned long start,
> +					   unsigned long nr_pages,
> +					   int write, int force,
> +					   struct page **pages,
> +					   struct vm_area_struct **vmas,
> +					   int *locked,
> +					   bool notify_drop)

You might want to consider __always_inline to make sure it does indeed
get inlined and constant propagation works for @locked and @notify_drop.
