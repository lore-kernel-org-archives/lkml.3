Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab3JYHBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 03:01:09 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:35879 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3JYHBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 03:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <87y55h7vcd.fsf@rustcorp.com.au>
References: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com>
	<87eh7bfoq9.fsf@rustcorp.com.au>
	<20131024084559.GD16735@n2100.arm.linux.org.uk>
	<87mwlyclng.fsf@rustcorp.com.au>
	<CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com>
	<87y55h7vcd.fsf@rustcorp.com.au>
Date: Fri, 25 Oct 2013 15:01:05 +0800
Message-ID: <CACVXFVPXEUX9JQ2NZvL8=J34zbw2fn202QW2SQtpKjdQ+tv=vg@mail.gmail.com>
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
From: Ming Lei <tom.leiming@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 1:50 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Ming Lei <tom.leiming@gmail.com> writes:
>> On Fri, Oct 25, 2013 at 7:08 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>
>>> Sorry, I was imprecise.  I was referring to the kernel's kallsyms
>>> tables produced by scripts/kallsyms.c.  This patch left them in the
>>> the kallsyms tables and filtered them out from /proc/kallsyms.
>>
>> Yes, but it isn't easy to do it by script/kallsyms.c , and IMO, it should
>> be correct to hide them for user space but keep them in kallsyms table.
>
> So they'll appear in backtraces?  And turn up randomly for other symbol
> dereferences?
>
> I don't think you really want this!

Basically these symbols are only used to generate code, and in
kernel mode, CPU won't run into the corresponding addresses
because the generate code is copied to other address during booting,
so I understand they won't appear in backtraces.


Thanks,
-- 
Ming Lei
