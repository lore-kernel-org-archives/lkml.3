Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab3CYVxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:53:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18502 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab3CYVxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:53:37 -0400
Message-ID: <5150C71A.3030802@oracle.com>
Date: Mon, 25 Mar 2013 17:52:26 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <5150B1C2.8090607@oracle.com> <20130325163844.042a45ba@annuminas.surriel.com> <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
In-Reply-To: <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 05:42 PM, Michel Lespinasse wrote:
> On Mon, Mar 25, 2013 at 1:38 PM, Rik van Riel <riel@surriel.com> wrote:
>> > On Mon, 25 Mar 2013 16:21:22 -0400
>> > Sasha Levin <sasha.levin@oracle.com> wrote:
>> >
>>> >> On 03/20/2013 03:55 PM, Rik van Riel wrote:
>>>> >> > Include lkml in the CC: this time... *sigh*
>>>> >> > ---8<---
>>>> >> >
>>>> >> > This series makes the sysv semaphore code more scalable,
>>>> >> > by reducing the time the semaphore lock is held, and making
>>>> >> > the locking more scalable for semaphore arrays with multiple
>>>> >> > semaphores.
>>> >>
>>> >> Hi Rik,
>>> >>
>>> >> I'm getting the following false positives from lockdep:
>> >
>> > Does this patch fix it?
> I'll be surprised if it does, because we don't actually have single
> depth nesting here...
> Adding Peter & Ingo for advice about how to proceed
> (the one solution I know would involve using arch_spin_lock() directly
> to bypass the lockdep checks, but there's got to be a better way...)

Yeah, it did not.


Thanks,
Sasha

