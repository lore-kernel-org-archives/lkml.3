Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbaGWRP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:15:26 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41768 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbaGWRPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140723170446.GA3935@laptop>
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
	<20140723170446.GA3935@laptop>
Date: Wed, 23 Jul 2014 10:15:23 -0700
X-Google-Sender-Auth: nzB8VZSzGQEkSTzft3z6O_K9Aqo
Message-ID: <CA+55aFxH=zWYmyfudWD4HWQFrGD9N6+ELbm130_tqEfzjMavAg@mail.gmail.com>
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

On Wed, Jul 23, 2014 at 10:04 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jul 23, 2014 at 09:54:23AM -0700, Linus Torvalds wrote:
>
>> So the length is fine, and the disassembly shows that it is fixed (16
>> 32-bit words - why the heck does it use "movsl" rather than "movsq",
>> whatever).
>
> Which is exactly right btw, he's got CONFIG_NR_CPUS=512 and 8*4*16=512.

That's not my point. Why the f*ck does it use "movsl", when "movsq"
should work as well or better.

Then it should use a count of 8. Because 8*8*8 is also 512 bits.

Of course, with the enhanced string instructions, it's quite possible
that "movsb" with a count of 64 (64*8) is the best option.

Anyway, my gcc version creates a series of 8 "movq" pairs instead,
which will beat all other cases, at the cost of much bigger code
footprint.

              Linus
