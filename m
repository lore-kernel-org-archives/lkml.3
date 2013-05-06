Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3EFRl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 13:41:56 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:65291 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3EFRlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 13:41:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130502073252.GG7521@dyad.programming.kicks-ass.net>
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
	<20130501090718.GA28253@dyad.programming.kicks-ass.net>
	<m261z3uipb.fsf@firstfloor.org>
	<20130501111219.GF28253@dyad.programming.kicks-ass.net>
	<CABPqkBT-VdWQ0c5AASDfQLssBRSfbtoH0-L1eHMXONqe5d_YRw@mail.gmail.com>
	<20130501191342.GH17814@two.firstfloor.org>
	<CABPqkBS7FxoT1fioe_VdBMcLAdZtfwRiMmSMocSY5TB3QAyPQQ@mail.gmail.com>
	<20130502073252.GG7521@dyad.programming.kicks-ass.net>
Date: Mon, 6 May 2013 19:41:54 +0200
Message-ID: <CABPqkBSqs8f9jomytPs5tyXMum1UCwSYHcTDuYwg0c-MTVvEow@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 9:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, May 01, 2013 at 09:21:55PM +0200, Stephane Eranian wrote:
>> On Wed, May 1, 2013 at 9:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> Unfortunately, Andi's patch fails to correct the problem though
>> >> it is the right approach. As he said, the problem is unfortunately
>> >
>> > perf stat -a / record -a / top will work.
>> >
>> But it does not for perf stat -a. Look at my example, run it on your machine.
>
>
> Since nobody seems interested in explaining the exact nature of the hardware
> failure I think the best thing we can do is simply blacklist these events.
>
> Broken hardware is broken after all -- we should jump through too many hoops
> pretending its not.

Problem is, those events are really important. We need to be able to
measure them.
