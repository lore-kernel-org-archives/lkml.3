Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074AbaJDQRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 12:17:16 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:49729 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJDQRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 12:17:15 -0400
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        linux-mips <linux-mips@linux-mips.org>,
        Zubair Kakakhel <Zubair.Kakakhel@imgtec.com>,
        David Daney <david.daney@cavium.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        "chenhc@lemote.com" <chenhc@lemote.com>,
        =?iso-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        James Hogan <James.Hogan@imgtec.com>,
        Kees Cook <keescook@chromium.org>,
        "alex@alex-smith.me.uk" <alex@alex-smith.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Crispin <blogic@openwrt.org>,
        "jchandra@broadcom.com" <jchandra@broadcom.com>,
        Paul Burton <Paul.Burton@imgtec.com>,
        Qais Yousef <Qais.Yousef@imgtec.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        "Manuel Lauss" <manuel.lauss@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "lars.persson@axis.com" <lars.persson@axis.com>
Subject: Re: [PATCH 0/3] MIPS executable stack protection
Thread-Topic: [PATCH 0/3] MIPS executable stack protection
Thread-Index: AQHP34Gysxw0os/VaEewjedDoGfZbpwgDy6AgACAvYD//45ViA==
Date: Sat, 4 Oct 2014 16:17:03 +0000
Message-ID: <vi8ojsasknll8us53fy9myb8.1412439420039@email.android.com>
References: <20141004030438.28569.85536.stgit@linux-yegoshin>
	<20141004082307.GS10583@worktop.programming.kicks-ass.net>,<CA+55aFynSp90n=jdUdmY7nq-9t4pHS82Tj-WfZOBfot7ip0hBw@mail.gmail.com>
In-Reply-To: <CA+55aFynSp90n=jdUdmY7nq-9t4pHS82Tj-WfZOBfot7ip0hBw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, it works on CPU with hardware page table walker - MIPS P5600 aka Apache.

I was involved in architecture development of HTW and took care of it.


Linus Torvalds <torvalds@linux-foundation.org> wrote:


On Sat, Oct 4, 2014 at 1:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Oct 03, 2014 at 08:17:14PM -0700, Leonid Yegoshin wrote:
>> The following series implements an executable stack protection in MIPS.
>>
>> It sets up a per-thread 'VDSO' page and appropriate TLB support.
>
> So traditionally we've always avoided per-thread pages like that. What
> makes it worth it on MIPS?

Nothing makes it worth it on MIPS.

It may be easy to implement when you have all software-fill of TLB's,
but it's a mistake even then - because it means that you'll never be
able to do hardware TLB walkers.

And MIPS *does* have hardware TLB walkers, even if they are not
necessarily available everywhere.

So this is a horrible idea. Don't do it. Page tables need to be
per-process, not per thread, so that page tables can be shared.

              Linus
