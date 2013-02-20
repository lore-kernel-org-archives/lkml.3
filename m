Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771Ab3BTSs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:48:59 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53593 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934293Ab3BTSs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:48:57 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<87k3qa7333.fsf@linaro.org>
	<CAFTL4hzH7avJLAvjBf3Px44s-BRRezTekrdQR4vSUhyFTYXwHA@mail.gmail.com>
Date: Wed, 20 Feb 2013 10:48:53 -0800
In-Reply-To: <CAFTL4hzH7avJLAvjBf3Px44s-BRRezTekrdQR4vSUhyFTYXwHA@mail.gmail.com>
	(Frederic Weisbecker's message of "Wed, 20 Feb 2013 16:44:24 +0100")
Message-ID: <877gm2rfca.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> 2013/2/15 Kevin Hilman <khilman@linaro.org>:
>> Frederic Weisbecker <fweisbec@gmail.com> writes:
>>
>>> Ingo,
>>>
>>> Please pull the new full dynticks cputime accounting code that
>>> can be found at:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>>>       tags/full-dynticks-cputime-for-mingo
>>>
>>> My last concern is the dependency on CONFIG_64BIT. We rely on cputime_t
>>> being u64 for reasonable nanosec granularity implementation. And therefore
>>> we need a single instruction fetch to read kernel cpustat for atomicity
>>> requirement against concurrent incrementation, which only 64 bit archs
>>> can provide.
>>
>> Actually, moderately recent 32-bit ARMs can do atomic 64-bit load/stores
>> too.
>
> Does gcc automatically handle 64 bit store/loads in one way or does
> that require specific CPU instructions?

For atomic load/stores, it requires specific instructions that gcc will
not generate, so the atomic64 accessors are needed on ARM.

Kevin
