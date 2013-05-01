Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab3EATWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:22:07 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:58545 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3EATV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130501191342.GH17814@two.firstfloor.org>
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
	<20130501090718.GA28253@dyad.programming.kicks-ass.net>
	<m261z3uipb.fsf@firstfloor.org>
	<20130501111219.GF28253@dyad.programming.kicks-ass.net>
	<CABPqkBT-VdWQ0c5AASDfQLssBRSfbtoH0-L1eHMXONqe5d_YRw@mail.gmail.com>
	<20130501191342.GH17814@two.firstfloor.org>
Date: Wed, 1 May 2013 21:21:55 +0200
Message-ID: <CABPqkBS7FxoT1fioe_VdBMcLAdZtfwRiMmSMocSY5TB3QAyPQQ@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 9:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Unfortunately, Andi's patch fails to correct the problem though
>> it is the right approach. As he said, the problem is unfortunately
>
> perf stat -a / record -a / top will work.
>
But it does not for perf stat -a. Look at my example, run it on your machine.

> The case it doesn't fix is per thread when the other sibling
> is not running a counter.
>
> Essentially with the patch you may still get under-counting
> on these specific events if they run per thread (or are really
> unlucky in multiplexing), but never over-counting on anything.
>
> In the past Ingo's guidance was to focus on the most common
> use cases, which I think this patch does.
>
> It would be possible to fix the per thread mode too, but it would
> need quite a bit of new infrastructure and I have doubts that's
> worth it.
>
> -Andi
