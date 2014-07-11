Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaGKO5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:57:32 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54579 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaGKO5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:57:30 -0400
Date: Fri, 11 Jul 2014 07:55:50 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Peter Zijlstra <peterz@infradead.org>
cc: Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
        davej@redhat.com, koct9i@gmail.com, lczerner@redhat.com,
        stable@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
 added to -mm tree
In-Reply-To: <53BFD708.1040305@oracle.com>
Message-ID: <alpine.LSU.2.11.1407110745430.2054@eggly.anvils>
References: <53BD1053.5020401@suse.cz> <53BD39FC.7040205@oracle.com> <53BD67DC.9040700@oracle.com> <alpine.LSU.2.11.1407092358090.18131@eggly.anvils> <53BE8B1B.3000808@oracle.com> <53BECBA4.3010508@oracle.com> <alpine.LSU.2.11.1407101033280.18934@eggly.anvils>
 <53BED7F6.4090502@oracle.com> <alpine.LSU.2.11.1407101131310.19154@eggly.anvils> <53BEE345.4090203@oracle.com> <20140711082500.GB20603@laptop.programming.kicks-ass.net> <53BFD708.1040305@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Sasha Levin wrote:
> 
> There's no easy way to see whether a given task is actually holding a lock or
> is just blocking on it without going through all those tasks one by one and
> looking at their trace.
> 
> I agree with you that "The call trace is very clear on it that its not", but
> when you have 500 call traces you really want something better than going
> through it one call trace at a time.

Points well made, and I strongly agree with Vlastimil and Sasha.
There is a world of difference between a lock wanted and a lock held,
and for the display of locks "held" to conceal that difference is unhelpful.
It just needs one greppable word to distinguish the cases.

(Though I didn't find "The call trace is very clear on it that its not",
I thought it too was telling me that the lock was already held somehow.)

Hugh
