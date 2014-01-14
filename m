Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaANSBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:01:14 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:60982 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaANSBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:01:10 -0500
Message-ID: <52D57B60.9020209@twiddle.net>
Date: Tue, 14 Jan 2014 10:01:04 -0800
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>, Peter Zijlstra <peterz@infradead.org>
CC: Daniel J Blueman <daniel@numascale.com>, Waiman Long <waiman.long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
References: <52D353C8.4000000@numascale.com> <52D4172E.6030706@hp.com> <52D4A0C7.5070601@numascale.com> <20140114110307.GW7572@laptop.programming.kicks-ass.net> <CAEdQ38GOSr+yk2=HApW3c0GM0MMysCvW6Fkd5UNMjS1ynrcZDg@mail.gmail.com>
In-Reply-To: <CAEdQ38GOSr+yk2=HApW3c0GM0MMysCvW6Fkd5UNMjS1ynrcZDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 09:08 AM, Matt Turner wrote:
> On Tue, Jan 14, 2014 at 3:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, Jan 14, 2014 at 10:28:23AM +0800, Daniel J Blueman wrote:
>>>> Peter,
>>>>
>>>> I found out that the build failure was caused by the fact that the
>>>> __native_word() macro (used internally by compiletime_assert_atomic())
>>>> allows only a size of 4 or 8 for x86-64. The data type that I used is a
>>>> byte. Is there a reason why byte and short are not considered native?
>>>
>>> It seems likely it was implemented like that since there was no existing
>>> need; long can be relied on as the largest native type, so this should
>>> suffice and works here:
>>
>> There's Alphas that cannot actually atomically adres a byte; I do not
>> konw if Linux cares about them, but if it does, we cannot in fact rely
>> on this in generic primitives like this.
> 
> That's right, and thanks for the heads-up. Alpha can only address 4
> and 8 bytes atomically. (LDL_L, LDQ_L, STL_C, STQ_C).
> 
> The Byte-Word extension in EV56 doesn't add new atomics, so in fact no
> Alphas can address < 4 bytes atomically.
> 

Emulated with aligned 4 byte atomics, and masking.  The same is true for arm,
ppc, mips which, depending on cpu, also lack < 4 byte atomics.


r~
