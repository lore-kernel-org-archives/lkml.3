Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3CVMPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:15:06 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57675 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CVMPE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Fri, 22 Mar 2013 08:15:04 -0400
Message-Id: <514C595D02000078000C7BA2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 22 Mar 2013 12:15:09 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Zhu Yanhai" <zhu.yanhai@gmail.com>
Cc: <x86@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Richard Weinberger" <richard@nod.at>,
        "Ingo Molnar" <mingo@redhat.com>, <muming.wq@taobao.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: How does spin_unlock() in x86-64 align with the
 description in Documention/memory-barriers.txt?
References: <CAC8teKU5H8r+uPqeytWNOsj+g+C0pN8LKdxz3+LzomoWXY6GrA@mail.gmail.com>
In-Reply-To: <CAC8teKU5H8r+uPqeytWNOsj+g+C0pN8LKdxz3+LzomoWXY6GrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.03.13 at 12:58, Zhu Yanhai <zhu.yanhai@gmail.com> wrote:
> Hi all,
> In the documention it reads,
> 
> (2) UNLOCK operation implication:
> 
>      Memory operations issued before the UNLOCK will be completed before the
>      UNLOCK operation has completed.
> 
>      Memory operations issued after the UNLOCK may be completed before the
>      UNLOCK operation has completed.
> 
> However, on x86-64 __ticket_spin_unlock() merely does,
> 
> static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
> {
>     asm volatile(
>         ALTERNATIVE(UNLOCK_LOCK_PREFIX"incb (%0);"ASM_NOP3,
>                 UNLOCK_LOCK_ALT_PREFIX"movw $0, (%0)",
>                 X86_FEATURE_UNFAIR_SPINLOCK)
>         :
>         : "Q" (&lock->slock)
>         : "memory", "cc");
> }
> 
> While both UNLOCK_LOCK_PREFIX and UNLOCK_LOCK_ALT_PREFIX are empty
> strings. So how such a function keeps the memory operations issued
> before it completed?

Please read the section "Memory Ordering in P6 and More Recent
Processor Families" in SDM Vol 3.

Jan

