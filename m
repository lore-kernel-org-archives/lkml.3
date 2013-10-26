Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab3JZJAC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 05:00:02 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:41001 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3JZJAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 05:00:00 -0400
Date: Sat, 26 Oct 2013 10:59:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
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
Subject: Re: ktap inclusion in drivers/staging/?
Message-ID: <20131026085955.GD14237@gmail.com>
References: <20131024075813.GA26929@gmail.com>
 <CAGdX0WFu=sxWUckkZiUQMTxo_tOFbxX-paqU2p_5YR8NaN6gSA@mail.gmail.com>
 <20131025101511.GB3439@gmail.com>
 <CAGdX0WGrGbb-eJvS4HHg9umk7X3-vrzyrJCuhAJrfGvOriKHSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WGrGbb-eJvS4HHg9umk7X3-vrzyrJCuhAJrfGvOriKHSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:

> Thanks. An addition question I want to discuss in here is the ktap 
> code structure layout in first patch series, this don't need to 
> dig out any ktap design detail, so we can make agreement on this 
> point, and ease for me to prepare patch series.
> 
> Do I need to prepare patchset target on staging tree or "real" 
> part of kernel? [...]

I'd suggest adding it to the core, i.e. kernel/tracing/ and 
kernel/trace/trace_events_filter.c in particular which includes the 
current filter script interpreter.

(Please also make sure that the Lua copyright notices get carried 
over properly.)

> [...] If target on driver/staging/ktap, then kernel code and 
> userspace code still need to locate at same directory, that many 
> people may don't like it.
> 
> Target on "real" part kernel? - include/trace/ktap (header file 
> common used by interpreter and userspace compiler) - 
> kernel/trace/ktap (interpreter code, ktapvm, pure kernel module) - 
> tools/perf/ktap?(userspace compiler code)
>   As I also agree integrating ktap and perf together, two 
>   subsystem can share many codes, so it's better putting ktap 
>   userspace into perf directory.

Once there's a more split-out submission it will be easier to see 
what belongs where. I agree with Pekka that for the user the UI 
should be integrated and obvious.

I'd also like there to be a natural 'extract the script' 
functionality from an installed tap script. This gives more 
flexibiliy and improves security as well: no hidden, binary-only 
crap, every script installed on a running system should be 
extractable in source form, should be reviewable and modifiable.

Thanks,

	Ingo
