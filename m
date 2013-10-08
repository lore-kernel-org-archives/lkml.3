Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3JHTtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:49:31 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:33874 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab3JHTta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <20131008193507.GA10145@redhat.com>
References: <20131005234430.GA22485@localhost>
	<CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
	<20131008075151.GA15689@localhost>
	<CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
	<20131008185154.GA8258@redhat.com>
	<20131008190523.GW30970@tucnak.zalov.cz>
	<20131008193507.GA10145@redhat.com>
Date: Tue, 8 Oct 2013 12:49:29 -0700
X-Google-Sender-Auth: I2cgxbtjutmv4paYlEpjU1gpNOw
Message-ID: <CA+55aFxsp-kiHxbp5gFKbGW7KJJyW=53pXnEP1O5q8LVYY6G0g@mail.gmail.com>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 12:35 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Cough... sorry for off-topic question,
>
>         static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
>         {
>                 int oldbit;
>
>                 asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
>                              "sbb %0,%0" : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
>
> doesn't this mean that "ADDR" doesn't need "+" as well?

We use ADDR for some of the non-barrier ones too, that don't have the
barrier. See clear_bit() and friends..

> Or at least, perhaps it makes sense to identify the include file which
> makes the difference. Say, revert the changes in bitops.h, retest, then
> in atomic.h if the kernel still fails, etc.

Yeah, except Fengguang is the only one seeing this in his automated tests..

              Linus
