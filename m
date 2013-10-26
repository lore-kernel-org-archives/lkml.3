Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3JZMbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 08:31:14 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:56155 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3JZMbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 08:31:13 -0400
MIME-Version: 1.0
In-Reply-To: <87sivp7eai.fsf@rustcorp.com.au>
References: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com>
	<87eh7bfoq9.fsf@rustcorp.com.au>
	<20131024084559.GD16735@n2100.arm.linux.org.uk>
	<87mwlyclng.fsf@rustcorp.com.au>
	<CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com>
	<87y55h7vcd.fsf@rustcorp.com.au>
	<CACVXFVPXEUX9JQ2NZvL8=J34zbw2fn202QW2SQtpKjdQ+tv=vg@mail.gmail.com>
	<87sivp7eai.fsf@rustcorp.com.au>
Date: Sat, 26 Oct 2013 20:31:12 +0800
Message-ID: <CACVXFVN7PiU1dorkeamtC9-Wg_TVQE8xFiJtad-C8q4_=Rc1Ow@mail.gmail.com>
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

On Fri, Oct 25, 2013 at 7:58 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> Basically these symbols are only used to generate code, and in
>> kernel mode, CPU won't run into the corresponding addresses
>> because the generate code is copied to other address during booting,
>> so I understand they won't appear in backtraces.
>
> An oops occurs when something went *wrong*.  We look up all kinds of
> stuff.  Are you so sure that *none* of the callers will ever see these
> strange symbols and produce a confusing result?

Suppose that might happen, kernel should be smart enough to know
that the address is not inside kernel address space and won't produce
confusing result, right?


Thanks,
-- 
Ming Lei
