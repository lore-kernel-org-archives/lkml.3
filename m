Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3LSTIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:08:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab3LSTIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:08:23 -0500
Date: Thu, 19 Dec 2013 20:08:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/1] mm: fix the theoretical compound_lock() vs
	prep_new_page() race
Message-ID: <20131219190846.GA24566@redhat.com>
References: <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de> <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com> <20131216183618.GA28252@redhat.com> <20131216201952.GE21218@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216201952.GE21218@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Andrea Arcangeli wrote:
>
> Can you reorder set_page_refcount in your v2?

Please see the patch.

> I wonder if arch_alloc_page needs refcount 1, it sets the page as
> stable on s390.

Obviously I have no idea what set_page_stable() does, but it works
with page_to_phys(), unlikely the content of "struct page" can matter.
And only s390 HAVE_ARCH_ALLOC_PAGE, I added Martin and Heiko.

> the other way around is to move prep_compound_page
> before set_page_refcounted (though I think if we can, keeping the
> refcounted at the very last with a comment is preferable).

Yes, yes, this looks much more natural.

Oleg.

