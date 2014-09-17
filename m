Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaIQJNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:13:43 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:58714 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbaIQJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140707200550.GA6758@twins.programming.kicks-ass.net>
References: <53B98709.3090603@oracle.com>
	<20140707083016.GA19379@twins.programming.kicks-ass.net>
	<53BAA6DF.5060409@oracle.com>
	<20140707200550.GA6758@twins.programming.kicks-ass.net>
Date: Wed, 17 Sep 2014 17:13:22 +0800
Message-ID: <CAGdX0WGfDm7jHreSREM8PdUUA9zcdDBz8rF2LJC-h7imfMq8jw@mail.gmail.com>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 4:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jul 07, 2014 at 09:55:43AM -0400, Sasha Levin wrote:
>> I've also had this one, which looks similar:
>>
>> [10375.005884] BUG: spinlock recursion on CPU#0, modprobe/10965
>> [10375.006573]  lock: 0xffff8803a0fd7740, .magic: dead4ead, .owner: modprobe/10965, .owner_cpu: 15
>> [10375.007412] CPU: 0 PID: 10965 Comm: modprobe Tainted: G        W      3.16.0-rc3-next-20140704-sasha-00023-g26c0906-dirty #765
>
> Something's fucked; so we have:
>
> debug_spin_lock_before()
>         SPIN_BUG_ON(lock->owner == current, "recursion");
>
> Causing that, _HOWEVER_ look at .owner_cpu and the reporting cpu!! How
> can the lock owner, own the lock on cpu 15 and again contend with it on
> CPU 0. That's impossible.
>
> About when-ish did you start seeing things like this? Lemme go stare
> hard at recent changes.

Peter, any new update on this issue?

Recently we also found a similar deadlock in our box, but with
3.4-stable kernel.

<0>[177064.149832] BUG: spinlock recursion on CPU#11, current: IVS_RcvReq1/16444
<0>[177064.149840]  lock: <NULL>/0xffff88017afd5640, .magic: dead4ead,
.owner: IVS_RcvReq1/16444, .owner_cpu: 14

Thanks.

Jovi
