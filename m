Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab3C2N7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:59:43 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:40994 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3C2N7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:59:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130329095558.5fffd95f@annuminas.surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5150B1C2.8090607@oracle.com>
	<20130325163844.042a45ba@annuminas.surriel.com>
	<CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
	<1364303965.5053.29.camel@laptop>
	<CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
	<1364308023.5053.40.camel@laptop>
	<5151BC78.3030306@surriel.com>
	<1364373750.5053.54.camel@laptop>
	<20130328162337.3003ccd4@cuia.bos.redhat.com>
	<CANN689GGwztb=beCNtUU8SJp6sfjn_mNTaHQxezt=ehtxvYBAA@mail.gmail.com>
	<20130329095558.5fffd95f@annuminas.surriel.com>
Date: Fri, 29 Mar 2013 06:59:41 -0700
Message-ID: <CANN689HTXusmGcLNByvmSQt0RGaCieZ3=YBJ-BSoeXXBO36=Xw@mail.gmail.com>
Subject: Re: [PATCH v3 -mm -next] ipc,sem: fix lockdep false positive
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@surriel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 6:55 AM, Rik van Riel <riel@surriel.com> wrote:
> On Thu, 28 Mar 2013 19:50:47 -0700
> Michel Lespinasse <walken@google.com> wrote:
>
>> This is IMO where the spin_unlock_wait(&sma->sem_perm.lock) would
>> belong - right before the goto again.
>
> Here is the slightly more optimistic (and probably more readable)
> version of the patch:
>
> ---8<---
> Unfortunately the locking scheme originally proposed has false positives
> with lockdep.  This can be fixed by changing the code to only ever take
> one lock, and making sure that other relevant locks are not locked, before
> entering a critical section.
>
> For the "global lock" case, this is done by taking the sem_array lock,
> and then (potentially) waiting for all the semaphore's spinlocks to be
> unlocked.
>
> For the "local lock" case, we wait on the sem_array's lock to be free,
> before taking the semaphore local lock. To prevent races, we need to
> check again after we have taken the local lock.
>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Looks good.

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
