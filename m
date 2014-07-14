Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaGNJkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:40:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25586 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaGNJkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:40:12 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-be-53c3a579fc12
Message-id: <53C3A430.9090508@samsung.com>
Date: Mon, 14 Jul 2014 13:34:40 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: sched, timers: use after free in __lock_task_sighand when exiting
 a process
References: <53C2FF4D.3020606@oracle.com> <53C31A34.8030500@oracle.com>
 <20140714090449.GL9918@twins.programming.kicks-ass.net>
In-reply-to: <20140714090449.GL9918@twins.programming.kicks-ass.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xK7qVSw8HGyzq07XYcr2JyWLm624m
	izO/dS0u75rDZrH63ylGi637WxktjvceYLJYfOQ2s8XmTVOZHTg9ds66y+6xeYWWx6ZVnWwe
	d67tYfN4d+4cu8fHp7dYPN7vu8rm8XmTXABHFJdNSmpOZllqkb5dAldG472VTAU3mCu+tr5i
	amD8xdTFyMkhIWAisaajkwXCFpO4cG89WxcjF4eQwFJGiel935ghnGYmiYnb9oBV8QpoSXx/
	/owVxGYRUJV48PIvO4jNJqAn8W/WdjYQW1QgQuJAH0QNr4CgxI/J98B6RQT8Jf7cewK2mRlk
	6M0pqSC2sECUxKnVJ8B6hQQaGSWu3vcBsTkFXCT+nGpjh6jXkdjfOo0NwpaX2LzmLfMERoFZ
	SFbMQlI2C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghUfFlB+PiY1aHGAU4GJV4
	eCvEDgcLsSaWFVfmHmKU4GBWEuE9Ox8oxJuSWFmVWpQfX1Sak1p8iJGJg1OqgbGpYlf41in/
	eRj2Myw1tVuxoNImPdZqUuSry/P6lXsm7X71MzAvbc4Ul0n3l+wSSXwTtDfl+OGi5PVxP68+
	qUwynPyV8cN7ZaYtHgwsVXM7nG0rdj0rzOVnrTxouvK+zJqfd5aYmxfc8+OcrTh5qticG8VB
	lr4Lt6QvcZvakj9B/bGA+sTXJ54osRRnJBpqMRcVJwIAOFmBMGgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/14 13:04, Peter Zijlstra wrote:
> On Sun, Jul 13, 2014 at 07:45:56PM -0400, Sasha Levin wrote:
>> On 07/13/2014 05:51 PM, Sasha Levin wrote:
>>> Hi all,
>>>
>>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>>> kernel with the KASAN patchset, I've stumbled on the following spew:
> 
> WTH is a KASAN?
> 

It's dynamic memory checker, detects use after free, out of bounds accesses - https://lkml.org/lkml/2014/7/9/990

