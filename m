Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161604Ab3FVAZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 20:25:18 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57168 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161521Ab3FVAZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 20:25:17 -0400
MIME-Version: 1.0
In-Reply-To: <1371859222.13136.11.camel@buesod1.americas.hpqcorp.net>
References: <1371858691.22432.3.camel@schen9-DESK>
	<1371859222.13136.11.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 21 Jun 2013 17:25:16 -0700
Message-ID: <CANN689G1hyV_+2DxOiLqHDLGGuCjAqn9GhV-g4A0Jfd6YRQupQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] rwsem: performance enhancements for systems with many cores
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 5:00 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> On Fri, 2013-06-21 at 16:51 -0700, Tim Chen wrote:
>> In this patchset, we introduce two optimizations to read write semaphore.
>> The first one reduces cache bouncing of the sem->count field
>> by doing a pre-read of the sem->count and avoid cmpxchg if possible.
>> The second patch introduces similar optimistic spining logic in
>> the mutex code for the writer lock acquisition of rw-sem.
>>
>> Combining the two patches, in testing by Davidlohr Bueso on aim7 workloads
>> on 8 socket 80 cores system, he saw improvements of
>> alltests (+14.5%), custom (+17%), disk (+11%), high_systime
>> (+5%), shared (+15%) and short (+4%), most of them after around 500
>> users when i_mmap was implemented as rwsem.
>>
>> Feedbacks on the effectiveness of these tweaks on other workloads
>> will be appreciated.
>
> Tim, I was really hoping to send all this in one big bundle. I was doing
> some further testing (enabling hyperthreading and some Oracle runs),
> fortunately everything looks ok and we are getting actual improvements
> on large boxes.
>
> That said, how about I send you my i_mmap rwsem patchset for a v2 of
> this patchset?

I'm a bit confused about the state of these patchsets - it looks like
I'm only copied into half of the conversations. Should I wait for a v2
here, or should I hunt down for Alex's version of things, or... ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
