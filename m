Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3KSSrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:47:41 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:50237 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3KSSri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:47:38 -0500
MIME-Version: 1.0
In-Reply-To: <20131119154253.GA12219@gmail.com>
References: <20131119154253.GA12219@gmail.com>
Date: Tue, 19 Nov 2013 10:47:36 -0800
X-Google-Sender-Auth: dQp3S00hQScV6r7gR93mmc1gaLs
Message-ID: <CA+55aFzyBxFi8_4C4hAz6+SAgtHCmQtpxSyJhRyWzggoRGTD5w@mail.gmail.com>
Subject: Re: [GIT PULL] core kernel update
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>, Josh Boyer <jwboyer@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 7:42 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Josh Boyer (1):
>       smp/cpumask: Make CONFIG_CPUMASK_OFFSTACK=y usable without debug dependency

This seems to be just pure stupid.

Why the hell should we ever ask the user whethr they want to force
CPUMASK offstack?

Seriously, it only leaves room for mistakes and stupidities. There is
no reason for any normal use-case to ask the user about this. Even the
help message is pure and utter garbage ("This is a bit more expensive,
but avoids stack overflow").

The fact is, an on-stack CPUMASK is *smaller* than a pointer to an
offstack one when NR_CPU is small. The question makes no sense then.
And when NR_CPU is huge, the question makes no sense _either_, since
we can't have the cpumasks on stack.

Asking the user questions that make no f*cking sense to ask is stupid.
And I'm not knowingly pulling stupid crap.

                   Linus
