Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaFBX4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:56:15 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49402 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaFBX4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:56:13 -0400
Date: Mon, 2 Jun 2014 16:54:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@kernel.org,
        peterz@infradead.org, riel@redhat.com, mgorman@suse.de, aswin@hp.com,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mm: i_mmap_mutex to rwsem
In-Reply-To: <1401741061.5185.9.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.LSU.2.11.1406021649570.5748@eggly.anvils>
References: <1400816006-3083-1-git-send-email-davidlohr@hp.com> <1401416415.2618.14.camel@buesod1.americas.hpqcorp.net> <20140602130832.9328cfef977b7ed837d59321@linux-foundation.org> <1401741061.5185.9.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014, Davidlohr Bueso wrote:
> On Mon, 2014-06-02 at 13:08 -0700, Andrew Morton wrote:
> > On Thu, 29 May 2014 19:20:15 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> > 
> > > On Thu, 2014-05-22 at 20:33 -0700, Davidlohr Bueso wrote:
> > > > This patchset extends the work started by Ingo Molnar in late 2012,
> > > > optimizing the anon-vma mutex lock, converting it from a exclusive mutex
> > > > to a rwsem, and sharing the lock for read-only paths when walking the
> > > > the vma-interval tree. More specifically commits 5a505085 and 4fc3f1d6.
> > > > 
> > > > The i_mmap_mutex has similar responsibilities with the anon-vma, protecting
> > > > file backed pages. Therefore we can use similar locking techniques: covert
> > > > the mutex to a rwsem and share the lock when possible.
> > > > 
> > > > With the new optimistic spinning property we have in rwsems, we no longer
> > > > take a hit in performance when using this lock, and we can therefore
> > > > safely do the conversion. Tests show no throughput regressions in aim7 or
> > > > pgbench runs, and we can see gains from sharing the lock, in disk workloads
> > > > ~+15% for over 1000 users on a 8-socket Westmere system.
> > > > 
> > > > This patchset applies on linux-next-20140522.
> > >
> > > ping? Andrew any chance of getting this in -next?
> > 
> > (top-posting repaired)
> > 
> > It was a bit late for 3.16 back on May 26, when you said "I will dig
> > deeper (probably for 3.17 now)".  So, please take another look at the
> > patch factoring and let's get this underway for -rc1.
> 
> Ok, so I meant that I'd dig deeper for the additional sharing
> opportunities (which I've found a few as Hugh correctly suggested). So
> those eventual patches could come later. 
> 
> But I see no reason for *this* patchset to be delayed, as even if it
> gets to be 3.17 material, I'd still very much want to have the same
> patch factoring I have now. I think its the correct way to handle lock
> transitioning for both correctness and bisectability.

I'd be glad to see it go into 3.16 if it works as well as advertized.
And if you're attached to your current 2/5, fine, do stick with that.
But please do a proper job on your 3/5, instead of just aping how the
anon case worked out.

Hugh
