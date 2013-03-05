Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab3CEUzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:55:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759287Ab3CEUzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:55:13 -0500
Message-ID: <51365B66.5010905@redhat.com>
Date: Tue, 05 Mar 2013 15:53:58 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Waiman Long <Waiman.Long@hp.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>,
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
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net> <513626E9.2040509@redhat.com> <51364AB9.80206@hp.com> <CA+55aFwYOUyG_DQUqVPrQNi_a=AUwS53U-Yi6jbvJTGRxQ_aEQ@mail.gmail.com>
In-Reply-To: <CA+55aFwYOUyG_DQUqVPrQNi_a=AUwS53U-Yi6jbvJTGRxQ_aEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 03:52 PM, Linus Torvalds wrote:
> On Tue, Mar 5, 2013 at 11:42 AM, Waiman Long <Waiman.Long@hp.com> wrote:
>>
>> The recommended kernel.sem value from Oracle is "250 32000 100 128". I have
>> tried to reduce the maximum semaphores per array (1st value) while
>> increasing the max number of arrays. That tends to reduce the ipc_lock
>> contention in kernel, but it is against Oracle's recommendation.
>
> Ok, the Oracle recommendations seem to be assuming that we'd be
> scaling the semaphore locking sanely, which we don't. Since we share
> one single lock for all semaphores in the whole array, Oracle's
> recommendation does the wrong thing for our ipc_lock contention.

> David's patch should make it much easier to do the locking more
> fine-grained, and it sounds like Rik is actively working on that,

Indeed.  Though how well my patches will work with Oracle will
depend a lot on what kind of semctl syscalls they are doing.

Does Oracle typically do one semop per semctl syscall, or does
it pass in a whole bunch at once?

-- 
All rights reversed
