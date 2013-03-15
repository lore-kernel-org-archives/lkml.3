Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3CORBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:01:52 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:65476 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3CORBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130315132607.GA4565@quad>
References: <20130315132607.GA4565@quad>
Date: Fri, 15 Mar 2013 10:01:50 -0700
X-Google-Sender-Auth: -2GA8pIDHML4dgdu_4gIIKcggns
Message-ID: <CA+55aFxqibqOvWcv691ZciO7rXpRFUL=zZVVGRSbD4N1Sz+fFQ@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephane Eranian <eranian@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 6:26 AM, Stephane Eranian <eranian@google.com> wrote:
>
> This patch fixes a kernel crash when using precise sampling (PEBS)
> after a suspend/resume.

Yup, works. Applied.

Can we please get rid of the crazy CPU notifier crap from the perf
code, and do this like we do most other wrmsr's etc? Doing

    git grep "case CPU_" arch/x86/kernel/cpu

shows that the perf layer seems to be full of this kind of BS. This is
all CPU state, it should be initialized by the regular CPU
initialization code, not hooked up with some random callbacks.

                  Linus
