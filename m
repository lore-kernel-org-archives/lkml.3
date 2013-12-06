Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3LFGXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:23:31 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52914 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3LFGX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:23:26 -0500
Message-ID: <52A16D49.9050105@hitachi.com>
Date: Fri, 06 Dec 2013 15:23:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <CA+b37P1ejFn4YJekJFOCe701mLTprqQi4KSyGV4S7QiVaC1=qA@mail.gmail.com>
In-Reply-To: <CA+b37P1ejFn4YJekJFOCe701mLTprqQi4KSyGV4S7QiVaC1=qA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/05 22:08), Sandeepa Prabhu wrote:
>> OK, I think the kprobe is like a strong medicine, not a toy,
>> since it can intercept most of the kernel functions which
>> may process a sensitive user private data. Thus even if we
>> fix all bugs and make it safe, I don't think we can open
>> it for all users (of course, there should be a knob to open
>> for any or restricted users.)
>>
>>> So we need both a maintainable and a sane/safe solution, and I'd like
>>> to apply the whole thing at once and be at ease that the solution is
>>> round. We should have done this years ago.
>>
>> For the safeness of kprobes, I have an idea; introduce a whitelist
>> for dynamic events. AFAICS, the biggest unstable issue of kprobes
>> comes from putting *many* probes on the functions called from tracers.
>>
>> It doesn't crash the kernel but slows down so much, because every
>> probes hit many other nested miss-hit probes. This gives us a big
>> performance impact. However, on the other side, this kind of feature
>> can be used *for debugging* static trace events by dynamic one if we
>> carefully use a small number of probes on such functions. :)
>>
>> Thus, I think we can restrict users from probing such functions by
>> using a whitelist which ftrace does already have;
>>  available_filter_functions :)
> I am not sure if this question is related, uprobes or ftrace code does
> not  define __kprobes, so is it safe to place kprobe on uprobes or
> ftrace code? 

Yes, it is "safe" in qualitative meaning. But for ftrace code, it could
give a performance impact by miss-hitting. Since uprobe is independent
from kprobe, it should work.

> Is it expected from arch code to support such cases?

Yes, the arch dependent implementation is the key. If it shares some
code which can be called from miss-hit path, it should be blacklisted.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


