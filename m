Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3JZFCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 01:02:51 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37630 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3JZFCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 01:02:50 -0400
MIME-Version: 1.0
In-Reply-To: <20131025101511.GB3439@gmail.com>
References: <20131024075813.GA26929@gmail.com>
	<CAGdX0WFu=sxWUckkZiUQMTxo_tOFbxX-paqU2p_5YR8NaN6gSA@mail.gmail.com>
	<20131025101511.GB3439@gmail.com>
Date: Sat, 26 Oct 2013 13:02:49 +0800
Message-ID: <CAGdX0WGrGbb-eJvS4HHg9umk7X3-vrzyrJCuhAJrfGvOriKHSQ@mail.gmail.com>
Subject: Re: ktap inclusion in drivers/staging/?
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 6:15 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>
>> >  - In a similar fashion, it would be nice to see it integrated with
>> >    'perf probe' or 'perf ktap', so that users can create probes from
>> >    a single place, with coherent syntax and integrated analysis
>> >    capabilities. I.e. there's no reason to not make this a
>> >    relatively pain-less yet very useful transition.
>>
>> Yes, I also mentioned this in my RFC email post before, that's the
>> reason why I use perf-like interface in ktap as much as I can,
>> like perf-tracepoints and perf-probe, also ktap can reuse perf
>> debuginfo handling code in future, we are on the same page at this
>> technical point.
>
> Okay, cool! I've also Cc:-ed Masami, who was also very receptive in
> person of the idea to merge this kind of scripting into perf probe.
>
> (or perf ktap, whichever structure makes most sense from the end
> user POV.)
>
Thanks. An addition question I want to discuss in here is the ktap code
structure layout in first patch series, this don't need to dig out any ktap
design detail, so we can make agreement on this point, and ease for me
to prepare patch series.

Do I need to prepare patchset target on staging tree or "real" part of kernel?
If target on driver/staging/ktap, then kernel code and userspace code still
need to locate at same directory, that many people may don't like it.

Target on "real" part kernel?
- include/trace/ktap (header file common used by interpreter and
userspace compiler)
- kernel/trace/ktap (interpreter code, ktapvm, pure kernel module)
- tools/perf/ktap?(userspace compiler code)
  As I also agree integrating ktap and perf together, two subsystem can share
  many codes, so it's better putting ktap userspace into perf directory.

Whatever the name calling of perf and ktap integrating, ktap still would be
a single directory, and could be compile into a standalone binary ktap.

How about this sounds?

Thanks.

Jovi
