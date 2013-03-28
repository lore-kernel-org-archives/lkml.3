Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab3C1DNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 23:13:48 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34844 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3C1DNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 23:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <5153B03E.2050201@gmail.com>
References: <alpine.LFD.2.03.1303272103380.8412@gmail.com>
	<5153B03E.2050201@gmail.com>
Date: Wed, 27 Mar 2013 23:13:45 -0400
Message-ID: <CAOULuOa1O5LxwDh6peSGBRR9PyeEtXuhyiaFVvKnFNiqrb4bfQ@mail.gmail.com>
Subject: Re: intel_pstate_timer_func divide by zero oops
From: Parag Warudkar <parag.lkml@gmail.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 10:51 PM, Dirk Brandewie
<dirk.brandewie@gmail.com> wrote:
>
> Is there any way to capture the beginning of this trace?

I tried but since the oops scrolls fast followed by a hard freeze, I
wasn't able to capture it completely.
May be I can try netconsole and see if that helps.

>
> pid_param_set() is on the stack which means that something is changing
> the debugfs parameters or the stack is FUBAR.
>
I somehow doubt the stack is messed up as the call traces are always identical.
(pid_param_set() seems to be in first trace as well.)

>
> I don't see how duration_us can be zero unless somehow I am getting
> back-to-back
> timer callbacks which seems unlikely since the timer is not re-armed until
> the timer function is about to return and the driver has done all its work
> for the sample period

Do the two oops with common call stack suggest back to back callbacks?

I will add some debugging checks tomorrow to see what is going on. But
sounds like a minimal fix would be to guard against callbacks in quick
succession?
i.e. return from sample if ktime_us_delta(now, cpu->prev_sample) is zero?

Thanks,
Parag
