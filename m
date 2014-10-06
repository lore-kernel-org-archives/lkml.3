Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaJFNoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:44:18 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:51301 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaJFNoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <20141006090726.GQ20170@rric.localhost>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
	<20140930132416.GB2799@kernel.org>
	<20141006090726.GQ20170@rric.localhost>
Date: Mon, 6 Oct 2014 15:44:16 +0200
Message-ID: <CAFrcx1nqoC1OLumt1bVhGJhJch-2RnYmRz4+kxmpVY6CpBSY6A@mail.gmail.com>
Subject: Re: perf & rasd integration plan
From: Jean Pihet <jean.pihet@linaro.org>
To: Robert Richter <rric@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6 October 2014 11:07, Robert Richter <rric@kernel.org> wrote:
> On 30.09.14 10:24:16, Arnaldo Carvalho de Melo wrote:
>> Em Tue, Sep 30, 2014 at 11:06:21AM +0200, Jean Pihet escreveu:
>> > The plan is to move the small and generic functions first: util,
>> > xyarray, cpumap, thread_map etc; then evlist, evsel, trace-event,
>> > trace-event-parse; and finally integrate rasd into the tools/ dir.
>> >
>> > Any thought? Can evlist, evsel etc. be moved at once?
>> >
>> > Patches should come soon, when time allows.
>>
>> Why don't you add it to tools/rasd/ and in tools/rasd/Makefile you just
>> go on and add tools/perf/util/evlist.o et all to be linked directly, as
>> a first step.
>>
>> Then, as a second step, we can create a tools/lib/perf/evlist.c having
>> what is currently used by both tools/perf/ and tools/rasd/, i.e. what is
>> proven to be useful for something other than perf.
>
> It would be good to have tools/lib/perf or so with some base
> implementation to setup and connect to perf buffers. This is useful
> for tools not only in tools/. The rasd would be a good reference for
> this regardless if it is in tools/ or not. I am not sure whether and
> when rasd will be moved there.

Agree. Having a lib (or a set of libs) that external tools can use is
a must. This will encourage tools developers to use this API instead
of re-invening the wheel every time, and to provide standard tools
that can be merged in the kernel source if needed.

>
>> As the need arises, we go on moving things into tools/lib/perf/evlist.c
>> et all from wherever it appeared first, be it from tools/rasd/,
>> tools/perf/util/evlist.c or anywhere else.
>>
>> Initial rule being that once it is used by multiple tools living in
>> tools/, then it deserves a place in tools/lib/perf/.
>
> So this wouldn't quite work well as it excludes tools not in tools/.
Ditto

I am willing to propose a first set of patches to factor out the
common code from perf, but an agreement is needed on the direction to
take.
My plan is to provide patches for the proposed integration plan (as in
the initial e-mail), is it worth doing so or is it purely wasted time
and effort?

What do you think?

Thx,
Jean

>
> -Robert
>
>>
>> Ditto for other stuff currently living in tools/perf/util/.
