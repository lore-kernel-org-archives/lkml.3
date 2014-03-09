Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaCIDWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 22:22:30 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:9972 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaCIDW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 22:22:29 -0500
Message-ID: <1394335345.11969.34.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v4] mm: per-thread vma caching
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 08 Mar 2014 19:22:25 -0800
In-Reply-To: <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net>
	 <20140308184040.GA29602@redhat.com>
	 <CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com>
	 <20140308194405.GA32403@redhat.com>
	 <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 12:02 -0800, Linus Torvalds wrote:
> On Sat, Mar 8, 2014 at 11:44 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Sure. But another thread or CLONE_VM task can do vmacache_invalidate(),
> > hit vmacache_seqnum == 0 and call vmacache_flush_all() to solve the
> > problem with potential overflow.
> 
> How?
> 
> Any invalidation is supposed to hold the mm semaphore for writing. And
> we should have it for reading.

Yes, invalidations are always with the write lock held. In any case it's
a good candidate to use verify_mm_writelocked(), even if it's only under
debug environments.

