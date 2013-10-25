Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab3JYFvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 01:51:33 -0400
Received: from ozlabs.org ([203.10.76.45]:50122 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3JYFvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 01:51:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
In-Reply-To: <CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com>
References: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com> <87eh7bfoq9.fsf@rustcorp.com.au> <20131024084559.GD16735@n2100.arm.linux.org.uk> <87mwlyclng.fsf@rustcorp.com.au> <CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 25 Oct 2013 16:20:10 +1030
Message-ID: <87y55h7vcd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:
> On Fri, Oct 25, 2013 at 7:08 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> Sorry, I was imprecise.  I was referring to the kernel's kallsyms
>> tables produced by scripts/kallsyms.c.  This patch left them in the
>> the kallsyms tables and filtered them out from /proc/kallsyms.
>
> Yes, but it isn't easy to do it by script/kallsyms.c , and IMO, it should
> be correct to hide them for user space but keep them in kallsyms table.

So they'll appear in backtraces?  And turn up randomly for other symbol
dereferences?

I don't think you really want this!

>> It's weird that cpu_v7_suspend_size appeared above, since kallsyms
>> should filter out 'A' symbols already.
>
> Sorry, the 'A' symbol is a mistake, but the others do exist in /proc/kallsyms.

Ah, OK.

Cheers,
Rusty.
