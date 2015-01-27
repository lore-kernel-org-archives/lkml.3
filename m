Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbbA0Hsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:48:37 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49701 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbA0Hsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:48:35 -0500
Message-ID: <54C742CC.6030409@gmail.com>
Date: Tue, 27 Jan 2015 08:48:28 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Torvald Riegel <triegel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: mtk.manpages@gmail.com, "Carlos O'Donell" <carlos@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        Darren Hart <dvhart@infradead.org>, Anton Blanchard <anton@samba.org>,
        Eric Dumazet <edumazet@google.com>,
        bill o gallmeister <bgallmeister@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>,
        Rich Felker <dalias@libc.org>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>	 <CF98E3EF.90564%dvhart@linux.intel.com>	 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>	 <5373D0CA.2050204@redhat.com>	 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>	 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>	 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>	 <54B7D87C.3090901@gmail.com> <1422037788.29655.0.camel@triegel.csb>	 <alpine.DEB.2.11.1501241116160.5526@nanos> <1422105142.29655.16.camel@triegel.csb>
In-Reply-To: <1422105142.29655.16.camel@triegel.csb>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Torvald,

On 01/24/2015 02:12 PM, Torvald Riegel wrote:
> On Sat, 2015-01-24 at 12:35 +0100, Thomas Gleixner wrote:
>> So we should never see -EINTR in the case of a spurious wakeup here.
>>
>> But, here is the not so good news:
>>
>>  I did some archaeology. The restart handling of futex_wait() got
>>  introduced in kernel 2.6.22, so anything older than that will have
>>  the spurious -EINTR issues.
>>
>> futex_wait_pi() always had the restart handling and glibc folks back
>> then (2006) requested that it should never return -EINTR, so it
>> unconditionally restarts the syscall whether a signal had been
>> delivered or not.
>>
>> So kernels >= 2.6.22 should never return -EINTR spuriously. If that
>> happens it's a bug and needs to be fixed.
> 
> Thanks for looking into this.
> 
> Michael, can you include the above in the documentation please?  This is
> useful for userspace code like glibc that expects a minimum kernel
> version.  Thanks!

I've added some text to my draft to cover this point.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
