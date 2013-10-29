Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab3J2DLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:11:55 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47998 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab3J2DLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:11:54 -0400
X-AuditID: 9c93017d-b7cd3ae000007ab3-59-526f27780f09
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
Date: Tue, 29 Oct 2013 12:11:52 +0900
In-Reply-To: <526E9429.20803@fb.com> (Arun Sharma's message of "Mon, 28 Oct
	2013 09:43:21 -0700")
Message-ID: <87mwls7ouf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

On Mon, 28 Oct 2013 09:43:21 -0700, Arun Sharma wrote:
> On 10/28/13 2:29 AM, Rodrigo Campos wrote:
>> On Mon, Oct 28, 2013 at 06:09:30PM +0900, Namhyung Kim wrote:
>>> On Mon, 28 Oct 2013 08:42:44 +0000, Rodrigo Campos wrote:
>>>> On Mon, Oct 28, 2013 at 02:09:49PM +0900, Namhyung Kim wrote:
>>>>> Anyway, You can find the series and discussion on the link below:
>>>>>
>>>>>    https://lkml.org/lkml/2012/9/13/81
>>>>
>>>> I've read the cover letter for that series and probably because I don't know
>>>> about perf internals I have a question: How will "--culumate" interact with
>>>> "--sort=dso" for example ?
>>>>
>>>> I mean, is it possible for that to show more than 100% ? (if you add all the
>>>> 93.35% in your example in the cover letter, or something similar). Or
>>>> "--culumate --sort=dso" will just group together all entries that have a dso in
>>>> the call chain ?
>>>
>>> Hmm.. I think --cumulate option is only meaningful when sort order
>>> includes symbol.  Maybe I can add support for --sort=dso case as well
>>> but not sure it's worth.  Do you think it's really needed?
>>
>> I don't know if it is *needed*, but that was what I need :)
>
> I suspect that users will find creative ways of using these options to
> solve real world problems and we shouldn't restrict usage any more
> than we need to to protect against obvious bugs/crashes.
>
> Also, what's the reasoning for --cumulate not being an option under
> perf record -g ..,<order>?

Sorry, I cannot understand you.  The 'perf record' just saves sample
data (and callchains) from the ring-buffer.  All the processing happens
in 'perf report'.  I can't see what you expect from the 'perf record
--cumulate'.  Am I missing something?

>
> In order to integrate perf record -b and --cumulate, we'll have to
> sort out the underlying infrastructure for processing callgraphs and
> branch stacks. I think the main roadblock here is that one is
> statistical and on many CPUs incomplete (only top N branches are
> reported).
>
> Given that there are clear use cases in production involving complex
> callgraphs, I'm for getting this support in first and then reconciling
> the differences with perf record -b later.

I think what Frederic said is that the code de-duplication of 'perf
report' side.  The branch stack and --cumulate are different - branch
stack concentrates on the branch itself but --cumulate uses callchains
to find parents and give some credit to them as side information.

Thanks,
Namhyung
