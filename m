Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3CERKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:10:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab3CERKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:10:33 -0500
Message-ID: <513626E9.2040509@redhat.com>
Date: Tue, 05 Mar 2013 12:10:01 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 04:35 AM, Davidlohr Bueso wrote:

> 2) While on an Oracle swingbench DSS (data mining) workload the
> improvements are not as exciting as with Rik's benchmark, we can see
> some positive numbers. For an 8 socket machine the following are the
> percentages of %sys time incurred in the ipc lock:
>
> Baseline (3.9-rc1):
> 100 swingbench users: 8,74%
> 400 swingbench users: 21,86%
> 800 swingbench users: 84,35%
>
> With this patchset:
> 100 swingbench users: 8,11%
> 400 swingbench users: 19,93%
> 800 swingbench users: 77,69%

Does the swingbench DSS workload use multiple semaphores, or
just one?

Your patches look like a great start to make the semaphores
more scalable. If the swingbench DSS workload uses multiple
semaphores, I have ideas for follow-up patches to make things
scale better.

What does ipcs output look like while running swingbench DSS?

-- 
All rights reversed
