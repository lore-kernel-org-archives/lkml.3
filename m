Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab3J2FZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:25:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58527 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3J2FZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:25:43 -0400
X-AuditID: 9c930197-b7b3eae00000122e-e0-526f46d66a90
From: Namhyung Kim <namhyung@kernel.org>
To: Arun Sharma <asharma@fb.com>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>, <namhyung.kim@lge.com>,
        <linux-kernel@vger.kernel.org>, <acme@ghostprotocols.net>,
        <fweisbec@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: State of "perf: Add a new sort order: SORT_INCLUSIVE"
References: <20131025150721.GA12534@sdfg.com.ar>
	<8761si9e1u.fsf@sejong.aot.lge.com>
	<20131028084244.GA7482@sdfg.com.ar>
	<877gcx92yd.fsf@sejong.aot.lge.com>
	<20131028092955.GB7482@sdfg.com.ar> <526E9429.20803@fb.com>
	<87mwls7ouf.fsf@sejong.aot.lge.com> <526F353E.8040607@fb.com>
Date: Tue, 29 Oct 2013 14:25:42 +0900
In-Reply-To: <526F353E.8040607@fb.com> (Arun Sharma's message of "Mon, 28 Oct
	2013 21:10:38 -0700")
Message-ID: <87d2mo7ind.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013 21:10:38 -0700, Arun Sharma wrote:
> On 10/28/13 8:11 PM, Namhyung Kim wrote:
>
> Hey Namhyung:
>
>>>
>>> Also, what's the reasoning for --cumulate not being an option under
>>> perf record -g ..,<order>?
>>
>> Sorry, I cannot understand you.  The 'perf record' just saves sample
>> data (and callchains) from the ring-buffer.  All the processing happens
>> in 'perf report'.  I can't see what you expect from the 'perf record
>> --cumulate'.  Am I missing something?
>
> Yes - I meant to say perf report -g :)

:)

>
>> -g [type,min[,limit],order]
>
> Specifically, along with callee, caller, we could have a third
> option. Or we could have a new type (graph, fractal, cumulative).

That's also fine by me.  But I added --cumulate since it's quite
different from other callchain behaviors.

If we go with -g option, I'd like add it as a new type.

>
>>> Given that there are clear use cases in production involving complex
>>> callgraphs, I'm for getting this support in first and then reconciling
>>> the differences with perf record -b later.
>>
>> I think what Frederic said is that the code de-duplication of 'perf
>> report' side.  The branch stack and --cumulate are different - branch
>> stack concentrates on the branch itself but --cumulate uses callchains
>> to find parents and give some credit to them as side information.
>
> Me too. I brought it up with Stephane at some point in the last year
> or so and there wasn't an obvious way to de-duplicate because of these
> differences.

Yeah, looking at the code, I can hardly find how I can do it. :-/

Thanks,
Namhyung
