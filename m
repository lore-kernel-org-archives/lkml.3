Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaFBUIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:08:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaFBUIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:08:34 -0400
Date: Mon, 2 Jun 2014 13:08:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, riel@redhat.com, mgorman@suse.de,
        aswin@hp.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mm: i_mmap_mutex to rwsem
Message-Id: <20140602130832.9328cfef977b7ed837d59321@linux-foundation.org>
In-Reply-To: <1401416415.2618.14.camel@buesod1.americas.hpqcorp.net>
References: <1400816006-3083-1-git-send-email-davidlohr@hp.com>
	<1401416415.2618.14.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 19:20:15 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> On Thu, 2014-05-22 at 20:33 -0700, Davidlohr Bueso wrote:
> > This patchset extends the work started by Ingo Molnar in late 2012,
> > optimizing the anon-vma mutex lock, converting it from a exclusive mutex
> > to a rwsem, and sharing the lock for read-only paths when walking the
> > the vma-interval tree. More specifically commits 5a505085 and 4fc3f1d6.
> > 
> > The i_mmap_mutex has similar responsibilities with the anon-vma, protecting
> > file backed pages. Therefore we can use similar locking techniques: covert
> > the mutex to a rwsem and share the lock when possible.
> > 
> > With the new optimistic spinning property we have in rwsems, we no longer
> > take a hit in performance when using this lock, and we can therefore
> > safely do the conversion. Tests show no throughput regressions in aim7 or
> > pgbench runs, and we can see gains from sharing the lock, in disk workloads
> > ~+15% for over 1000 users on a 8-socket Westmere system.
> > 
> > This patchset applies on linux-next-20140522.
>
> ping? Andrew any chance of getting this in -next?

(top-posting repaired)

It was a bit late for 3.16 back on May 26, when you said "I will dig
deeper (probably for 3.17 now)".  So, please take another look at the
patch factoring and let's get this underway for -rc1.

