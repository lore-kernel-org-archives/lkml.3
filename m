Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaIXK3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:29:30 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:39049 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaIXK33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:29:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1409232335500.4604@nanos>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
	<1410168160-3624-2-git-send-email-lftan@altera.com>
	<CAFiDJ5-b_P7aWFXYP4GcgTUb3t_j6dZCsjeGZwVUs+7qo0v-GA@mail.gmail.com>
	<alpine.DEB.2.10.1409232335500.4604@nanos>
Date: Wed, 24 Sep 2014 18:29:27 +0800
X-Google-Sender-Auth: mkC0uKw3qAoU-6-ifLhzg6cWkJI
Message-ID: <CAFiDJ5-quwwfG9LuouwWqawB6LyG57R2v7murCLVa0oC+zg2aA@mail.gmail.com>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
From: Ley Foon Tan <lftan@altera.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 5:47 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 23 Sep 2014, LF.Tan wrote:
>> On Mon, Sep 8, 2014 at 5:22 PM, Ley Foon Tan <lftan@altera.com> wrote:
>> > Follow m68k futex implementation for !CONFIG_SMP.
>
> Great. Follow arch/random implementation blindly and copy all the bugs
> in it.
>
>> > +static inline int
>> > +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
>> > +                             u32 oldval, u32 newval)
>> > +{
>> > +       u32 val;
>> > +
>> > +       if (unlikely(get_user(val, uaddr) != 0))
>> > +               return -EFAULT;
>> > +
>> > +       if (val == oldval && unlikely(put_user(newval, uaddr) != 0))
>> > +               return -EFAULT;
>> > +
>> > +       *uval = val;
>> > +
>> > +       return 0;
>> > +}
>
> Care to explain how this works reliably and resembles proper cmpxchg
> semantics under all circumstances?

kernel/futex.c:cmpxchg_futex_value_locked() is already called to
pagefault_disable() before call to futex_atomic_cmpxchg_inatomic().
For UP kernel and pagefault_disable() also means there is no preemption.

Regards
Ley Foon
