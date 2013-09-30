Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3I3Tf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:35:28 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:42358 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3I3TfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:35:23 -0400
Message-ID: <5249D26C.8020208@hp.com>
Date: Mon, 30 Sep 2013 15:35:08 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH, v2] anon_vmas: Convert the rwsem to an rwlock_t
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>  <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>  <20130928074144.GA17773@gmail.com>  <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>  <20130928192123.GA8228@gmail.com> <20130928193739.GA8642@gmail.com>  <CA+55aFyMXxH-PGewqxse=VJzMdHWkyN4iKMh-VgQ1X2yJFnAgw@mail.gmail.com>  <20130928195207.GA31245@gmail.com> <1380561027.3467.196.camel@schen9-DESK>  <20130930181411.GO15690@laptop.programming.kicks-ass.net> <1380568987.3467.198.camel@schen9-DESK>
In-Reply-To: <1380568987.3467.198.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 03:23 PM, Tim Chen wrote:
> On Mon, 2013-09-30 at 20:14 +0200, Peter Zijlstra wrote:
>> On Mon, Sep 30, 2013 at 10:10:27AM -0700, Tim Chen wrote:
>>> Here's the exim workload data:
>>>
>>> rwsem improvment:
>>> Waimain's patch:        +2.0%
>>> Alex+Tim's patchset:    +4.8%
>>> Waiman+Alex+Tim:        +5.3%
>>>
>>> convert rwsem to rwlock_t for root anon_vma lock
>>> Ingo's patch		+11.7%
>>>
>> What happens if you stuff Waiman's qrwlock patches on top of that?
>> admittedly and oft mentioned in this thread, our current rwlock_t is
>> somewhat suboptimal under a number of conditions.
> I've tested with Waiman's qrwlock patches on top of Ingo's patches.
> It does not affect the throughput for exim and I still get
> about +11.7% throughput change (same as with Ingo's patch only).
>
> Tim
>

My qrwlock doesn't enable qrwlock by default. You have to use menuconfig 
to explicitly enable it. Have you done that when you build the test 
kernel? I am thinking of explicitly enabling it for x86 if the anon-vma 
lock is converted back to a rwlock.

-Longman
