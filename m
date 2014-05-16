Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbaEPR4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:56:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbaEPR4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:56:37 -0400
Message-ID: <5376512F.6080308@redhat.com>
Date: Fri, 16 May 2014 13:55:59 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
CC: Darren Hart <dvhart@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <537313FD.4000306@redhat.com> <alpine.DEB.2.02.1405141034320.6261@ionos.tec.linutronix.de> <20140514100705.GH30445@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1405141227170.6261@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405141227170.6261@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 06:28 AM, Thomas Gleixner wrote:
> On Wed, 14 May 2014, Peter Zijlstra wrote:
>> On Wed, May 14, 2014 at 11:53:44AM +0200, Thomas Gleixner wrote:
>>>> What error would we return?
>>>>
>>>> This particular case is a serious error for which we have no good error code
>>>> to return to userspace. It's an implementation defect, a bug, we should probably
>>>> assert instead of pausing.
>>>
>>> Errm.
>>>
>>> http://pubs.opengroup.org/onlinepubs/7908799/xsh/pthread_mutex_lock.html
>>>
>>>  The pthread_mutex_lock() function may fail if:
>>>
>>>   [EDEADLK]
>>>     The current thread already owns the mutex. 
>>>
>>> That's a exactly the error code, which the kernel returns when it
>>> detects a deadlock. 
>>>
>>> And glibc returns EDEADLK at a lot of places already. So in that case
>>> it's not a serious error? Because it's detected by glibc. You can't be
>>> serious about that.
>>>
>>> So why is a kernel detected deadlock different? Because it detects not
>>> only AA, it detects ABBA and more. But it's still a dead lock. And
>>> while posix spec only talks about AA, it's the very same issue.
>>>
>>> So why not propagate this to the caller so he gets an alert right away
>>> instead of letting him attach a debugger, and scratch his head and
>>> lookup glibc source to find out why the hell glibc called pause.
>>
>>   http://pubs.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_lock.html
> 
> Yuck. I should not have used the first link Gurgle brought up.

For the record the correct link is for POSIX Issue 7 (Issue 8 under development).

http://pubs.opengroup.org/onlinepubs/9699919799/functions/pthread_mutex_lock.html

The Issue 7 version has a nice table :}

Cheers,
Carlos.

