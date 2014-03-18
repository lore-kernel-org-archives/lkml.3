Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaCROLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:11:33 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60232 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbaCROLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140318131831.GN31482@ghostprotocols.net>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
 <1394437440-11609-3-git-send-email-namhyung@kernel.org> <20140317200832.GE31482@ghostprotocols.net>
 <CAM9d7ch0xHO4S6drn_G2CELTD6G51ADE+XvvSJw5Jid2Dy7Khw@mail.gmail.com>
 <20140318131518.GM31482@ghostprotocols.net> <20140318131831.GN31482@ghostprotocols.net>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 18 Mar 2014 23:11:10 +0900
X-Google-Sender-Auth: N0k5jJQevdKQ1_dAiYnNUweODYU
Message-ID: <CAM9d7cjWBM1jOCc20v7AVxP05JZnvc0bjrgY6JAFaZfo+bYLPg@mail.gmail.com>
Subject: Re: [PATCH 2/9] perf tools: Count periods of filtered entries separately
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 10:18 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Tue, Mar 18, 2014 at 10:15:18AM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Tue, Mar 18, 2014 at 01:19:07PM +0900, Namhyung Kim escreveu:
>> > On Tue, Mar 18, 2014 at 5:08 AM, Arnaldo Carvalho de Melo
>> > <acme@ghostprotocols.net> wrote:
>> > > Em Mon, Mar 10, 2014 at 04:43:53PM +0900, Namhyung Kim escreveu:
>> > >> @@ -749,9 +750,6 @@ int perf_event__preprocess_sample(const union perf_event *event,
>> > >>       if (thread == NULL)
>> > >>               return -1;
>> > >>
>> > >> -     if (thread__is_filtered(thread))
>> > >> -             goto out_filtered;
>> > >> -
>> > >
>> > > What was the intent of moving this test from here...
>> > >
>> > >>       dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
>> > >>       /*
>> > >>        * Have we already created the kernel maps for this machine?
>> > >> @@ -766,6 +764,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
>> > >>
>> > >>       thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
>> > >>                             sample->ip, al);
>> > >> +
>> > >> +     if (thread__is_filtered(thread))
>> > >> +             al->filtered |= (1 << HIST_FILTER__THREAD);
>> > >> +
>> > >
>> > > ... to here? At first I thought it was because thread__is_filtered()
>> > > would check something that thread__find_addr_map() was doing, but no,
>> > > its invariant, we can do it here or at the original site, so I'm keeping
>> > > it there, ok?
>> >
>> > It's because thread__find_addr_map() clears al->filtered, so filtering
>> > with -d option won't work.  Maybe we can move initialization of the
>> > al->filtered upto this function.
>>
>> So this is a separate patch with this explanation, I'll add it to the
>> series, thanks for the explanation!
>
> Humm, it really needs to be folded into the patch that does all the
> tests, as before we were just stopping the filters early and thus no
> problem existed, its only now that we apply all the filters that we need
> to be careful in knowing that thread__find_addr_map() is when
> al->filtered gets initialized to zero, right?

Right. :)

Thanks,
Namhyung
