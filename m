Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3J1Dfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 23:35:40 -0400
Received: from ozlabs.org ([203.10.76.45]:47516 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab3J1Dfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:35:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
In-Reply-To: <CACVXFVN7PiU1dorkeamtC9-Wg_TVQE8xFiJtad-C8q4_=Rc1Ow@mail.gmail.com>
References: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com> <87eh7bfoq9.fsf@rustcorp.com.au> <20131024084559.GD16735@n2100.arm.linux.org.uk> <87mwlyclng.fsf@rustcorp.com.au> <CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com> <87y55h7vcd.fsf@rustcorp.com.au> <CACVXFVPXEUX9JQ2NZvL8=J34zbw2fn202QW2SQtpKjdQ+tv=vg@mail.gmail.com> <87sivp7eai.fsf@rustcorp.com.au> <CACVXFVN7PiU1dorkeamtC9-Wg_TVQE8xFiJtad-C8q4_=Rc1Ow@mail.gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 28 Oct 2013 13:44:30 +1030
Message-ID: <874n82gk89.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:
> On Fri, Oct 25, 2013 at 7:58 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>
>>> Basically these symbols are only used to generate code, and in
>>> kernel mode, CPU won't run into the corresponding addresses
>>> because the generate code is copied to other address during booting,
>>> so I understand they won't appear in backtraces.
>>
>> An oops occurs when something went *wrong*.  We look up all kinds of
>> stuff.  Are you so sure that *none* of the callers will ever see these
>> strange symbols and produce a confusing result?
>
> Suppose that might happen, kernel should be smart enough to know
> that the address is not inside kernel address space and won't produce
> confusing result, right?

I don't know...  It would be your job, as the person making the change,
to find all the users of kallsyms and prove that.

This is why it is easier not to include incorrect values in the kernel's
kallsyms in the first place.

Hope that helps,
Rusty.
