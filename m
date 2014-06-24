Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaFXKs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:48:28 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33406 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaFXKs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:48:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140624080347.GL13930@laptop.programming.kicks-ass.net>
References: <0dfbe2976aa108c53e08d3477ea90f6360c1f54c.1403584026.git.viresh.kumar@linaro.org>
	<20140624080347.GL13930@laptop.programming.kicks-ass.net>
Date: Tue, 24 Jun 2014 16:18:26 +0530
Message-ID: <CAKohpomVO5H+peZe53U9=cGkRKNB9HVZZe02n+2pByLYJs1G5w@mail.gmail.com>
Subject: Re: [PATCH] sched/idle: Drop !! while calculating 'broadcast'
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2014 13:33, Peter Zijlstra <peterz@infradead.org> wrote:
> All true; but does it change anything? That is, does your compiler
> generate better code because of this?

Compilers are smart enough now a days and may not  perform !!
at all I believe.. And so this patch is more about code clarity ..

I tried comparing results for ARM and got this with/without
this patch ..

$ size ../bexynos/kernel/sched/idle.o
   text   data    bss    dec    hex filename
    690     30      0    720    2d0 ../bexynos/kernel/sched/idle.o

Don't know if some architectures are using somewhat dumb
compilers which might result in better code with this patch :)
