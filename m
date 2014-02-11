Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaBKLE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:04:26 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:32806 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaBKLEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:04:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140211110242.GU9987@twins.programming.kicks-ass.net>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
	<20140210212955.GC5002@laptop.programming.kicks-ass.net>
	<CABPqkBRzvfcdKGG4yY9q1PmtVL5Z=9H1RzHg8QDMN42a7=AF6A@mail.gmail.com>
	<20140211071401.GG27965@twins.programming.kicks-ass.net>
	<CABPqkBRn+AVUA-KTx-JQ28j1NhE4pDQe5vjb5NKGx0jrZq8g_Q@mail.gmail.com>
	<20140211105217.GS9987@twins.programming.kicks-ass.net>
	<CABPqkBROriDQa5-b-w45zV+2gS94oEW1c_bYwGmYAeYcqPoUog@mail.gmail.com>
	<20140211110242.GU9987@twins.programming.kicks-ass.net>
Date: Tue, 11 Feb 2014 12:04:23 +0100
Message-ID: <CABPqkBQhUCUOszQzBJZd_pwX-nLf6y=0X-+swPi0pE3ivRpVcg@mail.gmail.com>
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Richard Fowles <fowles@inreach.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Feb 11, 2014 at 11:58:45AM +0100, Stephane Eranian wrote:
>> On Tue, Feb 11, 2014 at 11:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, Feb 11, 2014 at 11:35:45AM +0100, Stephane Eranian wrote:
>> >> On Tue, Feb 11, 2014 at 8:14 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> >
>> >> > That blows; how much is missing?
>> >>
>> >> They need to annotate load and stores. I asked for that feature a while ago.
>> >> It will come.
>> >
>> > And there is no way to deduce the information? We have type information
>> > for all arguments and local variables, right? So we can follow that.
>> >
>> > struct foo {
>> >         int ponies;
>> >         int moar_ponies;
>> > };
>> >
>> > struct bar {
>> >         int my_ponies;
>> >         struct foo *foo;
>> > };
>> >
>> > int moo(struct bar *bar)
>> > {
>> >         return bar->foo->moar_ponies;
>> > }
>> >
>> > Since we have the argument type, we can find the type for both loads,
>> > the first load:
>> >
>> >   *bar+8, we know is: struct foo * bar::foo
>> >   *foo+4, we know is: int foo::moar_ponies
>> >
>> > Or am I missing something?
>>
>> How do you know that load at addr 0x1000 is accessing variable bar?
>> The IP gives you line number, and then what?
>> I think dwarf has the mapping regs -> variable and yes, the type info.
>> But I am not sure that's enough.
>
> Ah, but if you have the instruction, you can decode it and obtain the
> reg and thus type-info, no?
>
But on x86, you can load directly from memory, you'd only have the
target reg for the load. Not enough.
