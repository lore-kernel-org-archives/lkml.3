Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab3DEXgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 19:36:25 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:51373 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab3DEXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 19:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130326201722.GA14220@linutronix.de>
References: <20130326201722.GA14220@linutronix.de>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Fri, 5 Apr 2013 19:35:51 -0400
X-Google-Sender-Auth: KezVKex0Gs-hN5oB6sxvYUj8Jos
Message-ID: <CAP=VYLoXfECaSBuvYdZ3qbsnR9QMYpoRnKGZdY=P6zS_TYOcCA@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8.4-rt2
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 4:17 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> Dear RT Folks,
>
> I'm pleased to announce the 3.8.4-rt2 release.
>
> changes since v3.8.4-rt1:
> - build fix for i915 (reported by "Luis Claudio R. Goncalves")
> - build fix for fscache (reported by tglx)
> - build fix for !RT (kernel/softirq.c did not compile)
> - per-cpu rwsem fixed for RT (required only by uprobes so far)
> - slub: delay the execution of the ->ctor() hook for newly created
>   objects. This lowers the worst case latencies.
>
> Known issues:
>
>       - SLxB is broken on PowerPC.
>
> The delta patch against v3.8.4-rt1 is appended below and can be found
> here:
>
>   https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.4-rt1-rt2.patch.xz
>
> The RT patch against 3.8.4 can be found here:
>
>   https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.4-rt2.patch.xz
>
> The split quilt queue is available at:
>
>   https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.4-rt2.tar.xz

Thanks for the work in putting this together.  Just a heads up that the
split queue fails on a patch with no author/date/subject as follows:

[...]
(174/286) Applying: rt-add-rt-to-mutex-headers.patch
(175/286) Applying: rwsem-add-rt-variant.patch
(176/286) Applying: rt: Add the preempt-rt lock replacement APIs
(177/286) Patch format detection failed.
git am of percpu-rwsem-compilefix.patch failed.

Looking at percpu-rwsem-compilefix.patch -- it starts with three dashes,
so it looks like the shortlog and long-log got inadvertently thrown out,
as well as any author or optional date information, etc.

Fixing that one, I get further, until I get to:

[...]
(270/286) Applying: wait-simple: Simple waitqueue implementation
(271/286) Applying: rcutiny: Use simple waitqueue
(272/286) Patch format detection failed.
git am of treercu-use-simple-waitqueue.patch failed.

This "treercu-use-simple-waitqueue.patch" has the exact same problem.

Note that I'm using git directly, and not quilt -- which is more
strict in what it will accept, hence it catches these kinds of things.

Thanks,
Paul.
--

> Sebastian
> ---
