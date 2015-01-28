Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbbA1V14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:27:56 -0500
Received: from mail-yk0-f182.google.com ([209.85.160.182]:43663 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934449AbbA1Uss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:48:48 -0500
MIME-Version: 1.0
In-Reply-To: <20150127164716.GH21418@twins.programming.kicks-ass.net>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
	<1421642980-10045-3-git-send-email-pang.xunlei@linaro.org>
	<20150127164716.GH21418@twins.programming.kicks-ass.net>
Date: Wed, 28 Jan 2015 23:18:34 +0800
Message-ID: <CADcy93XVn9akNoHaFJfWxRtszRpF_O0dnGa7iZHBFcYsfBWpCg@mail.gmail.com>
Subject: Re: [PATCH 3/5] sched/deadline: Fix wrong cpudl_find() in check_preempt_equal_dl()
From: Xunlei Pang <pang.xunlei@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 28 January 2015 at 00:47, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jan 19, 2015 at 04:49:38AM +0000, Xunlei Pang wrote:
>> In check_preempt_equal_dl(), cpudl_find() is called with a NULL
>> later_mask, thus cpudl_find() here doesn't check cpudl::free_cpus
>> at all.
>>
>> This patch takles this issue by always passing a non-NULL later_mask
>> to cpudl_find(), thereby fixing this issue.
>
> Fix what issue? Afaict this is an optimization not a fix.

Currently, check_preempt_equal_dl() invokes cpudl_find() with a NULL mask,
so cpudl_find() won't check cpudl::free_cpus. For example, 4 core
system, CPU0~CPU2
are all idle(free of deadline tasks), a deadline task is woken on CPU3
which already
has one running deadline task with the same deadline value, then
cpudl_find() will fail
causing CPU3 holding 2 deadline tasks while other cpus are idle,
obviously it should
be placed on one idle cpu.

Thanks,
Xunlei
