Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaAUShE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:37:04 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:64307 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbaAUShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:37:00 -0500
MIME-Version: 1.0
In-Reply-To: <52DE8231.6080408@zytor.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
	<CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
	<CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
	<52DDAD9D.9030504@zytor.com>
	<20140121090003.GO31570@twins.programming.kicks-ass.net>
	<52DE8231.6080408@zytor.com>
Date: Tue, 21 Jan 2014 10:37:00 -0800
X-Google-Sender-Auth: u3qTBGPEdArm07q1uEYbgqjtkHQ
Message-ID: <CAGXu5jLdz2b2gozgK_TWjUzGacwyD_qb47Yc8rkmWkzVe1zcWg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 6:20 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/21/2014 01:00 AM, Peter Zijlstra wrote:
>>>
>>> So this is presumably something that needs to be fixed in perf?
>>
>> Where do we learn about the offset from userspace?
>
> Now this is tricky... if this offset is too easy to get it completely
> defeats kASLR.  On the other hand, I presume that if we are exporting
> /proc/kcore we're not secure anyway.  Kees, I assume that in "secure"
> mode perf annotations simply wouldn't work anyway?

The goal scope of the kernel base address randomization is to keep it
secret from non-root users, confined processes, and/or remote systems.
For local secrecy, if you're running with kaslr and you haven't set
kptr_restrict, dmesg_restrict, and perf_event_paranoid, that's a
problem since you're likely leaking things trivially through
/proc/kallsyms, dmesg, and/or perf.

-Kees

-- 
Kees Cook
Chrome OS Security
