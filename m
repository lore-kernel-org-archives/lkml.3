Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3CNUcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:32:32 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:42067 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3CNUcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:32:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130226070247.GA14094@gmail.com>
References: <20130226070247.GA14094@gmail.com>
Date: Thu, 14 Mar 2013 13:32:30 -0700
X-Google-Sender-Auth: mhUWgIxRhQ4R53leWY40jfEaEAs
Message-ID: <CA+55aFxdR6_8734T9y2Edyotf0u-SgPPgjazFuQa1atSUGK9LA@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:02 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Stephane Eranian (1):
>       perf/x86: Add Intel IvyBridge event scheduling constraints

So thanks to my new Chromebook, I'm trying to do perf stuff on
IvyBridge. I was hoping the whole exact cycle counting would work
better, since the last machine it was reliable for me was my old
Westmere desktop, and my previous laptop (Sandybridge MacBook Air)
didn't work very well due to CPU errata.

Sadly, my new Ivybridge laptop doesn't seem to do very well either,
but I suspect it's the kernel, not the hardware this time. A simple

    perf record -f -e cycles:pp make -j

in the kernel directory (fully built kernel, so the load doesn't
actually go crazy despite the "-j") will *sometimes* totally hang the
machine with current git.

I get a NULL pointer dereference in intel_pmu_enable_all, so I don't
think it's a hardware bug.

And to make things interesting, I seem to be able to only reproduce
this *after* a suspend cycle. That may be just happenstance, since it
seemed to be hard to replicate and most of the time it has happened
under X with no messages visible at all, but that *seems* to be the
pattern.

And the one time I got it to happen on the text console, things
scrolled off (watchdog warnings due to lockups), but I did get a NULL
pointer dereference in intel_pmu_enable_all().

I'll try to reproduce it and get a picture, but thought I'd send out
the email with just this, since maybe the "suspend cycle" plus "NULL
pointer in intel_pmu_enable_all()" makes somebody go "Duh!", or at
least replicate it...

                  Linus
