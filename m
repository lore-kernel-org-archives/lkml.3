Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3CFDyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 22:54:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3CFDyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 22:54:02 -0500
Message-ID: <5136BDC1.70804@redhat.com>
Date: Tue, 05 Mar 2013 22:53:37 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
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
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net> <513626E9.2040509@redhat.com> <51364AB9.80206@hp.com> <CA+55aFwYOUyG_DQUqVPrQNi_a=AUwS53U-Yi6jbvJTGRxQ_aEQ@mail.gmail.com> <51365B66.5010905@redhat.com> <5136BC33.5000608@hp.com>
In-Reply-To: <5136BC33.5000608@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 10:46 PM, Waiman Long wrote:
> On 03/05/2013 03:53 PM, Rik van Riel wrote:

>> Indeed.  Though how well my patches will work with Oracle will
>> depend a lot on what kind of semctl syscalls they are doing.
>>
>> Does Oracle typically do one semop per semctl syscall, or does
>> it pass in a whole bunch at once?
>
> i had collected a strace log of Oracle instance startup a while ago. In
> the log, almost all of the semctl() call is to set a single semaphore
> value in one of the element of the array using SETVAL. Also there are
> far more semtimedop() than semctl(), about 100:1. Again, all the
> semtimedop() operations are on a single element of the semaphore array.

That is good to hear. Just what I was hoping when I started
working on my patches. You should expect them tomorrow or
Thursday.

-- 
All rights reversed
