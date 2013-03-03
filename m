Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3CCCT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 21:19:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab3CCCT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 21:19:27 -0500
Message-ID: <5132B2FB.4020004@redhat.com>
Date: Sat, 02 Mar 2013 21:18:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/2] ipc: introduce obtaining a lockless ipc object
References: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net> <CANN689EqgPZVw=Sy_WAkB+=MJJCZeRMq_CmF1gec+cRVCS2xtA@mail.gmail.com>
In-Reply-To: <CANN689EqgPZVw=Sy_WAkB+=MJJCZeRMq_CmF1gec+cRVCS2xtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 11:32 PM, Michel Lespinasse wrote:

> I think it may be nicer to take the rcu read lock at the call site
> rather than in ipc_obtain_object(), to make the rcu read lock/unlock
> sites pair up more nicely. Either that or make an inline
> ipc_release_object function that pairs up with ipc_obtain_object() and
> just does an rcu_read_unlock().

I started on a patch series to untangle the IPC locking, so
it will be a little more readable, and easier to maintain.

It is a slower approach than Davidlohr's, as in, it will take
a little longer to put a patch series together, but I hope it
will be easier to debug...

I hope to post a first iteration of the series by the middle
of next week.

-- 
All rights reversed
