Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbaG3DKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:10:38 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33001 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbaG3DKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:10:33 -0400
Message-ID: <53D86226.7020207@linaro.org>
Date: Tue, 29 Jul 2014 20:10:30 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
References: <20140725144522.32c1f6b5@canb.auug.org.au> <20140730095642.5f68e01d@canb.auug.org.au>
In-Reply-To: <20140730095642.5f68e01d@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 04:56 PM, Stephen Rothwell wrote:
> Hi all,
>
> On Fri, 25 Jul 2014 14:45:22 +1000 Stephen Rothwell
<sfr@canb.auug.org.au> wrote:
>>
>> Hi all,
>>
>> After merging the tip tree, today's linux-next build (powerpc
>> ppc64_defconfig) failed like this:
>>
>> arch/powerpc/kernel/time.c:743:6: error: conflicting types for
'update_vsyscall_old'
>>  void update_vsyscall_old(struct timespec *wall_time, struct timespec
*wtm,
>>       ^
>> In file included from arch/powerpc/kernel/time.c:77:0:
>> include/linux/timekeeper_internal.h:114:13: note: previous
declaration of 'update_vsyscall_old' was here
>>  extern void update_vsyscall_old(struct timespec *ts, struct timespec
*wtm,
>>              ^
>>
>> Caused by commit 4a0e637738f0 ("clocksource: Get rid of cycle_last").
>>
>> I have used the tip tree from next-20140724 for today.
>
> Ping?
So I sent a fix for this the other day ([PATCH] timekeeping: Fixup typo
in update_vsyscall_old definition), but I've not heard anything from
anyone on it.


thanks
-john

