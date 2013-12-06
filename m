Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3LFGyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:54:32 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59103 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3LFGyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:54:31 -0500
MIME-Version: 1.0
In-Reply-To: <52A16D49.9050105@hitachi.com>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
	<20131204084551.GA31772@gmail.com>
	<529FBA71.6070107@hitachi.com>
	<CA+b37P1ejFn4YJekJFOCe701mLTprqQi4KSyGV4S7QiVaC1=qA@mail.gmail.com>
	<52A16D49.9050105@hitachi.com>
Date: Fri, 6 Dec 2013 12:24:29 +0530
Message-ID: <CA+b37P3BywWsuNgjVfvxxK2acAbV7qd6R5UJd1UEYdHHuQ56ag@mail.gmail.com>
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

>> I am not sure if this question is related, uprobes or ftrace code does
>> not  define __kprobes, so is it safe to place kprobe on uprobes or
>> ftrace code?
>
> Yes, it is "safe" in qualitative meaning. But for ftrace code, it could
> give a performance impact by miss-hitting. Since uprobe is independent
> from kprobe, it should work.
>
>> Is it expected from arch code to support such cases?
>
> Yes, the arch dependent implementation is the key. If it shares some
> code which can be called from miss-hit path, it should be blacklisted.
well, isn't the blacklist only for those routines that can not be
handled or may crash kernel, like the code sections called from
exception kprobes exception handlers etc?
suppose if the probe on routine can miss-hit (probes re-cursing) but
can be handled, it's only a quantitative issue (i.e. performance
impact) so it should be *user's* problem right? I mean, as you said
earlier about having white-list or a performance gatekeeper
(systemtap), one can avoid such cases by white list or removing
miss-hit probes dynamically.  But a blacklisting a symbol means
placing a probe on that *can not be handled* and can crash the system,
is it correct?

Thanks,
Sandeepa

>
> Thank you,
>
> --
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
>
>
