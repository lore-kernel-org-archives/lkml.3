Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3LENIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:08:09 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61165 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab3LENIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <529FBA71.6070107@hitachi.com>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
	<20131204084551.GA31772@gmail.com>
	<529FBA71.6070107@hitachi.com>
Date: Thu, 5 Dec 2013 18:38:04 +0530
Message-ID: <CA+b37P1ejFn4YJekJFOCe701mLTprqQi4KSyGV4S7QiVaC1=qA@mail.gmail.com>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, I think the kprobe is like a strong medicine, not a toy,
> since it can intercept most of the kernel functions which
> may process a sensitive user private data. Thus even if we
> fix all bugs and make it safe, I don't think we can open
> it for all users (of course, there should be a knob to open
> for any or restricted users.)
>
>> So we need both a maintainable and a sane/safe solution, and I'd like
>> to apply the whole thing at once and be at ease that the solution is
>> round. We should have done this years ago.
>
> For the safeness of kprobes, I have an idea; introduce a whitelist
> for dynamic events. AFAICS, the biggest unstable issue of kprobes
> comes from putting *many* probes on the functions called from tracers.
>
> It doesn't crash the kernel but slows down so much, because every
> probes hit many other nested miss-hit probes. This gives us a big
> performance impact. However, on the other side, this kind of feature
> can be used *for debugging* static trace events by dynamic one if we
> carefully use a small number of probes on such functions. :)
>
> Thus, I think we can restrict users from probing such functions by
> using a whitelist which ftrace does already have;
>  available_filter_functions :)
I am not sure if this question is related, uprobes or ftrace code does
not  define __kprobes, so is it safe to place kprobe on uprobes or
ftrace code? Is it expected from arch code to support such cases?

Thanks,
Sandeepa
