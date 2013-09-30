Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3I3QDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:03:30 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:6035 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab3I3QD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:03:29 -0400
Message-ID: <5249A0C4.7050306@hp.com>
Date: Mon, 30 Sep 2013 12:03:16 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Michel Lespinasse <walken@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com> <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com> <20130928074144.GA17773@gmail.com> <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com> <CANN689GLde8ZY5yLadbgGrC3eagrY_quQRnTdD_nywP8m1McjA@mail.gmail.com> <20130930070551.GC13584@gmail.com>
In-Reply-To: <20130930070551.GC13584@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 03:05 AM, Ingo Molnar wrote:
> * Michel Lespinasse<walken@google.com>  wrote:
>
>> That said, I am very scared of using rwlock_t here, and I would much
>> prefer we choose a fair lock (either spinlock or a new rwlock
>> implementation which guarantees not to starve any locker thread)
> Given how few users rwlock_t has today we could attempt to make it
> reader-writer fair, as long as the usecase of a hardirq or softirq
> context always getting nested read access on the same CPU is preserved.
>
> (but that can be done - if nothing else then with an explicit context
> check.)
>
> Thanks,
>
> 	Ingo

My queue rwlock patch is able to handle the use case of a hardirq and 
softirq context and can be made almost as fair as the ticket spinlock.

-Longman
