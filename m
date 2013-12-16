Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3LPUSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:18:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab3LPUSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:18:36 -0500
Date: Mon, 16 Dec 2013 21:19:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/2] mm: thp: get_huge_page_tail() cleanups
Message-ID: <20131216201900.GA6616@redhat.com>
References: <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com> <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de> <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213173406.GG5408@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On top of

	mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch

should not be applied without the ack from Andrea.

On 12/13, Andrea Arcangeli wrote:
>
> The above diff looks a straightforward cleanup you could submit it as
> a separate patch in a v2 series.

OK, let me send this separately, because (afaics) put_compound_tail()
needs more thinking.

See also 2/2. Again, I won't argue if you dislike this change even if
it is correct, so please review and ack/nack. To me compound_head() in
get_huge_page_tail() looks confusing, as if get_huge_page_tail() can
accept a !PageTail page. But perhaps this is only because I am new to
this code.

Oleg.

