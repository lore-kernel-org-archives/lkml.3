Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaDGQik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:38:40 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:49781 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbaDGQie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:38:34 -0400
Message-ID: <5342D475.7060503@hp.com>
Date: Mon, 07 Apr 2014 12:38:13 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v8 00/10] qspinlock: a 4-byte queue spinlock with PV support
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com> <5342425A.7040005@linux.vnet.ibm.com>
In-Reply-To: <5342425A.7040005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 02:14 AM, Raghavendra K T wrote:
>
>
> I tested the v7,v8 of qspinlock with unfair config on kvm guest.
> I was curious about unfair locks performance in undercommit cases. 
> (overcommit case is expected to perform well)
>
> But I am seeing hang in overcommit cases. Gdb showed that many vcpus
> are halted and there was no progress. Suspecting the problem /race with
> halting, I removed the halt() part of kvm_hibernate().  I am yet to 
> take a closer look at the code on halt() related changes.

It seems like there may still be race conditions where the current code 
is not handling correctly. I will look into that to see where the 
problem is. BTW, what test do you use to produce the hang condition?

>
> Patch series with that change gave around 20% improvement for dbench 
> 2x and 30% improvement for ebizzy 2x cases. (1x has no significant 
> loss/gain).
>
>

What is the baseline for the performance improvement? Is it without the 
unfair lock and PV qspinlock?

-Longman

