Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbbAXNN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 08:13:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbbAXNNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 08:13:25 -0500
Subject: Re: futex(2) man page update help request
From: Torvald Riegel <triegel@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "Carlos O'Donell" <carlos@redhat.com>,
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
In-Reply-To: <alpine.DEB.2.11.1501241116160.5526@nanos>
References: <537346E5.4050407@gmail.com>
	 <CF98E3EF.90564%dvhart@linux.intel.com>
	 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
	 <5373D0CA.2050204@redhat.com>
	 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
	 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
	 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
	 <54B7D87C.3090901@gmail.com> <1422037788.29655.0.camel@triegel.csb>
	 <alpine.DEB.2.11.1501241116160.5526@nanos>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jan 2015 14:12:22 +0100
Message-ID: <1422105142.29655.16.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-24 at 12:35 +0100, Thomas Gleixner wrote:
> So we should never see -EINTR in the case of a spurious wakeup here.
> 
> But, here is the not so good news:
> 
>  I did some archaeology. The restart handling of futex_wait() got
>  introduced in kernel 2.6.22, so anything older than that will have
>  the spurious -EINTR issues.
> 
> futex_wait_pi() always had the restart handling and glibc folks back
> then (2006) requested that it should never return -EINTR, so it
> unconditionally restarts the syscall whether a signal had been
> delivered or not.
> 
> So kernels >= 2.6.22 should never return -EINTR spuriously. If that
> happens it's a bug and needs to be fixed.

Thanks for looking into this.

Michael, can you include the above in the documentation please?  This is
useful for userspace code like glibc that expects a minimum kernel
version.  Thanks!

