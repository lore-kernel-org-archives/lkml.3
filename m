Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaGWRMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:12:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36249 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaGWRMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140723170324.GZ3935@laptop>
References: <20140723082819.GR3935@laptop>
	<20140723092536.GO12054@laptop.lan>
	<53CF80EE.5050702@daenzer.net>
	<53CF844A.5050106@arm.com>
	<20140723111110.GT3935@laptop>
	<20140723113021.GP12054@laptop.lan>
	<20140723142454.GQ12054@laptop.lan>
	<CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
	<20140723155526.GW3935@laptop>
	<CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
	<20140723170324.GZ3935@laptop>
Date: Wed, 23 Jul 2014 10:12:35 -0700
X-Google-Sender-Auth: dLiuLm37tTKliK7Txc5UEGJv_Lk
Message-ID: <CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jul 23, 2014 at 09:54:23AM -0700, Linus Torvalds wrote:
>>
>> And I wonder if I have a clue. Look, load_balance_mask is a
>> "cpumask_var_t", but I don't see a "alloc_cpumask_var()" for it.
>> That's broken with CONFIG_CPUMASK_OFFSTACK.
>
> kernel/sched/core.c:sched_init()
>
> plays horrible allocation tricks..

No it does not. It allocates a cpumask. Nothing more. If you think it
allocates a "cpumask_var()", you are wrong.

I agree that the code is an unreadable mess, but that's what
"cpumask_size()" is: the minimum required size of the bitmask in a
cpumask.

A cpumask_var is TOTALLY DIFFERENT. It's *either* a cpumask _or_ just
a pointer to an externally allocated cpumask.

sched_init() definitely does _not_ allocate a cpumask_var.

                Linus
