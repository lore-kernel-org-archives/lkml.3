Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936929Ab3DJO3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:29:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759532Ab3DJO3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:29:46 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130410120228.GC8083@gmail.com>
References: <1364489605-5443-1-git-send-email-sgruszka@redhat.com> <1364489605-5443-5-git-send-email-sgruszka@redhat.com> <20130410120228.GC8083@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC 4/4] cputime: remove scaling
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 10 Apr 2013 07:29:21 -0700
To: Ingo Molnar <mingo@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <11f12774-5353-4380-82d0-e22707e11729@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a patch that does scaling by multiply for 64-bit architectures.  I probably should clean it up and send it in.  I need to see if it fixes this problem.

Ingo Molnar <mingo@kernel.org> wrote:

>
>* Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
>> Scaling cputime cause problems, bunch of them was fixed, but still is
>possible 
>> to hit multiplication overflow issue, which make {u,s}time values
>incorrect. 
>> This problem has no good solution in kernel.
>
>Wasn't 128-bit math a solution to the overflow problems? 128-bit math
>isn't nice, 
>but at least for multiplication it's defensible.
>
>> This patch remove scaling code and export raw values of {u,t}ime .
>Procps 
>> programs can use newly introduced sum_exec_runtime to find out
>precisely 
>> calculated process cpu time and scale utime, stime values
>accordingly.
>> 
>> Unfortunately times(2) syscall has no such option.
>> 
>> This change affect kernels compiled without
>CONFIG_VIRT_CPU_ACCOUNTING_*.
>
>So, the concern here is that 'top hiding' code can now hide again. It's
>also that 
>we are not really solving the problem, we are pushing it to user-space
>- which in 
>the best case gets updated to solve the problem in some similar fashion
>- and in 
>the worst case does not get updated or does it in a buggy way.
>
>So while user-space has it a bit easier because it can do floating
>point math, is 
>there really no workable solution to the current kernel side integer
>overflow bug? 
>I really prefer robust kernel side accounting/instrumentation.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
