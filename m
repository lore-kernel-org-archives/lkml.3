Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3JBFNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:13:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58113 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3JBFNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:13:20 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20131002050714.GA27982@gmail.com>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org> <20131002050714.GA27982@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 0/7] Kernel base address randomization
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 01 Oct 2013 22:11:37 -0700
To: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        kernel-hardening@lists.openwall.com, adurbin@google.com,
        Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com,
        Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <fcdac020-6b9a-4d36-b424-290597669cb0@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that the randomization offset would be necessary in order to identify pointers.

Ingo Molnar <mingo@kernel.org> wrote:
>
>* Kees Cook <keescook@chromium.org> wrote:
>
>> Here is the latest version of the kASLR series. It has much improved 
>> e820 walking code, and expands the window available on 64-bit.
>> 
>> This is rolled out on Chrome OS devices, and working well.
>
>There's one kernel debuggability detail that should be discussed I
>think: 
>should symbolic printouts (in oops messages but also in /proc/kallsyms)
>
>and instrumentation interfaces that expose kernel addresses attempt to 
>de-randomize the addresses, stack contents and register values that lie
>
>within the random range?
>
>- it would be easier to use those addresses and look them up in a
>vmlinux
>   or in a System.map as well.
>
> - it would be somewhat safer to post an oops publicly if it did not
>   contain the random offset in an easily identifiable way.
>
>- oops patterns from distribution kernels that enable randomization
>would 
>   match up better.
>
> - this would make it safer to expose /proc/kallsyms to user-space
>   profiling, while keeping the random offset a kernel-internal secret.
>
> - RIP information in profiling streams would thus not contain the
>   kernel random offset either.
>
>The other approach would be what your series does, to keep all the raw,
>
>randomized output and to assume that users who are allowed to access to
>
>logs or profiling can learn the random offset.
>
>I tend to lean towards the 'raw' approach that you picked, but an
>argument 
>can be made for both approaches - and in any case I haven't seen this 
>discussed to conclusion with cons/pros listed and a consensus/decision 
>reached.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
