Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaJMH37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:29:59 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:43847 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaJMH36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:29:58 -0400
MIME-Version: 1.0
In-Reply-To: <20141010204432.GD13017@pd.tnic>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
	<20141006212606.GF14113@kernel.org>
	<CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
	<20141007133236.GG14113@kernel.org>
	<20141007140433.GG30146@pd.tnic>
	<20141010200708.GB18775@kernel.org>
	<20141010202854.GC13017@pd.tnic>
	<20141010204158.GA13834@kernel.org>
	<20141010204432.GD13017@pd.tnic>
Date: Mon, 13 Oct 2014 09:29:57 +0200
Message-ID: <CAFrcx1nm4pqWPsUtj1h5qQqo6dghiafRM60-9asaYXx7NLqAEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo, Borislav,

On 10 October 2014 22:44, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Oct 10, 2014 at 05:41:58PM -0300, Arnaldo Carvalho de Melo wrote:
>> Right, stoopid me, no need for some specific tracepoint, just to see
>> that whatever tp it is, it will show up in "rasd"'s event loop. Ok, I'll
>> try that later.
>>
>> Next stuff I probably will do is to move the bare minimum used by rasd
>> to tools/lib/api/perf/, i.e. there will be:
>>
>> tools/lib/api/perf/evsel.c
>> tools/perf/util/evsel.c
>>
>> Both will share the perf_evsel__ namespace (which I thought at some
>> point to make just: evsel__<METHOD_NAME>, wdyt?).
Makes perfectly sense

>>
>> That way we just make public the bare minimum that already proved to be
>> useful outside tools/perf/ and over time we move stuff from
>> tools/perf/util/evsel.c (and from other tools in or out perf's repo)
>> into the lib.
That is great!

About rasd usage, there are some details at
https://wiki.linaro.org/LEG/Engineering/Kernel/perfAndRAS#rasd_implementation.

Thx,
Jean

>
> Abso-f*cking-lutely!
>
> :-D
>
>> Np, had to be done at some point :)
>
> Yeah, cool. Let me know what I should do to help out.
>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
