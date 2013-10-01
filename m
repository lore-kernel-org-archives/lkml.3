Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3JAUDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:03:38 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:10360 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3JAUDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:03:23 -0400
Message-ID: <524B2A7E.9080006@hp.com>
Date: Tue, 01 Oct 2013 16:03:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com> <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com> <20130928074144.GA17773@gmail.com> <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com> <20130928192123.GA8228@gmail.com> <CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com> <52499FA5.60701@hp.com> <20131001073301.GA20889@gmail.com>
In-Reply-To: <20131001073301.GA20889@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 03:33 AM, Ingo Molnar wrote:
> * Waiman Long<waiman.long@hp.com>  wrote:
>
>>> I think Waiman's patches (even the later ones) made the queued rwlocks
>>> be a side-by-side implementation with the old rwlocks, and I think
>>> that was just being unnecessarily careful. It might be useful for
>>> testing to have a config option to switch between the two, but we
>>> might as well go all the way.
>> It is not actually a side-by-side implementation. A user can choose
>> either regular rwlock or the queue one, but never both by setting a
>> configuration parameter. However, I now think that maybe we should do it
>> the lockref way by pre-determining it on a per-architecture level
>> without user visible configuration option.
> Well, as I pointed it out to you during review, such a Kconfig driven
> locking API choice is a no-go!
>
> What I suggested instead: there's absolutely no problem with providing a
> better rwlock_t implementation, backed with numbers and all that.
>
> Thanks,
>
> 	Ingo

Yes, this is what I am planning to do. The next version of my qrwlock 
patch will force the switch to queue rwlock for x86 architecture. The 
other architectures have to be done separately.

-Longman

