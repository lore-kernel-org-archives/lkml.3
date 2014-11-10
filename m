Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaKJGdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:33:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:37988 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaKJGdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:33:13 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on NO_LIBELF=1
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
	<20141107082723.GB23531@worktop.programming.kicks-ass.net>
	<1415372259.1648.51.camel@leonhard>
	<20141107173718.GD29390@twins.programming.kicks-ass.net>
Date: Mon, 10 Nov 2014 15:33:11 +0900
In-Reply-To: <20141107173718.GD29390@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Fri, 7 Nov 2014 18:37:18 +0100")
Message-ID: <87mw7zva3c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, 7 Nov 2014 18:37:18 +0100, Peter Zijlstra wrote:
> On Fri, Nov 07, 2014 at 11:57:39PM +0900, Namhyung Kim wrote:
>
>> > Why does this live in the minimal implementation; should we not always
>> > discard ELF files with 0 symbols?
>> > 
>> > Suppose I have a vmlinux but removed all symbols from it; I want it to
>> > fall back to kallsyms too.
>> 
>> I'm not sure I understood what you said correctly.  With this change,
>> dso__load_kernel_sym() always ends up calling dso__load_kallsyms() since
>> dso__load_vmlinux() will always return 0;
>> 
>> So I think you'll fall back to kallsyms even though you have a vmlinux
>> with symbol.  This makes dso__load_sym() in the patch 2/3 simpler IMHO.
>
> But why have it specific to the minimal elf thing? Why not discard any
> DSO with 0 symbols and try the next option to acquire symbols?

Hmm.. I don't think it's specific to the minimal elf parser.  The return
value of dso__load_sym() is a number of symbols found so when it sees a
dso with 0 symbols it'll fall back to the next option IMHO (not
tested).  Did you see a problem with the current code?

Thanks,
Namhyung
