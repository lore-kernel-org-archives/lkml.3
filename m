Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254Ab3LTOT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:19:27 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:59532 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030197Ab3LTOTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:19:25 -0500
Date: Fri, 20 Dec 2013 15:19:17 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 0/1] mm: fix the theoretical compound_lock() vs
 prep_new_page() race
Message-ID: <20131220151917.54309071@mschwide>
In-Reply-To: <20131219190846.GA24566@redhat.com>
References: <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
	<20131211170844.GA21700@redhat.com>
	<alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de>
	<20131211175615.GA24546@redhat.com>
	<20131211191855.GA32485@redhat.com>
	<20131213151035.GE5408@redhat.com>
	<20131213162240.GA11762@redhat.com>
	<20131213173406.GG5408@redhat.com>
	<20131216183618.GA28252@redhat.com>
	<20131216201952.GE21218@redhat.com>
	<20131219190846.GA24566@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122014-2966-0000-0000-000009C0CA6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 20:08:46 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 12/16, Andrea Arcangeli wrote:
> >
> > Can you reorder set_page_refcount in your v2?
> 
> Please see the patch.
> 
> > I wonder if arch_alloc_page needs refcount 1, it sets the page as
> > stable on s390.
> 
> Obviously I have no idea what set_page_stable() does, but it works
> with page_to_phys(), unlikely the content of "struct page" can matter.
> And only s390 HAVE_ARCH_ALLOC_PAGE, I added Martin and Heiko.

On s390 the arch_alloc_page primitive is used to tell the hipervisor
that a page is going to be used. While the page is free it is marked
as "unused" which allows the hipervisor to throw away the page content
if the page is selected to be swapped. We do have a patch to add the
host support for KVM somewhere in our queue.

The content of the "struct page" does not matter at all for the
set-stable/set-unused state transition, s390 does not care about
the refcount in its arch_alloc_page function.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

