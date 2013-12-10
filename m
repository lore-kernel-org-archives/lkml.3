Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3LJWJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:09:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab3LJWJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:09:08 -0500
Date: Tue, 10 Dec 2013 23:09:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210220941.GA7766@redhat.com>
References: <20131210154724.GA30020@redhat.com> <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com> <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de> <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com> <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com> <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Linus Torvalds wrote:
>
> So it looks like __get_user_pages_fast() fails, and keeps failing.

And "again:" does get_user_pages_fast().

And according to this trace get_user_pages_fast() takes mmap_sem
and calls __get_user_pages().

But __get_user_pages() should fail even before follow_page_mask()
due to fatal_signal_pending(), in this case get_futex_key() should
return the error. is_vm_hugetlb_page(vma).

So it seems that this is not THP but VM_HUGETLB and
follow_hugetlb_page() succeeds every time?

Oleg.

