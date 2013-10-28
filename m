Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab3J1Itk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:49:40 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:48999 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3J1Iti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:49:38 -0400
MIME-Version: 1.0
In-Reply-To: <8761si9e1u.fsf@sejong.aot.lge.com>
References: <20131025150721.GA12534@sdfg.com.ar>
	<8761si9e1u.fsf@sejong.aot.lge.com>
Date: Mon, 28 Oct 2013 09:49:37 +0100
Message-ID: <CAFTL4hwn1r2JzfmXchXgXrNhM6q6F=M93WfviuWEbWSuBN6E_A@mail.gmail.com>
Subject: Re: State of "perf: Add a new sort order: SORT_INCLUSIVE"
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Melo <acme@ghostprotocols.net>, Arun Sharma <asharma@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/28 Namhyung Kim <namhyung@kernel.org>:
> Hi Rodrigo,
>
> On Fri, 25 Oct 2013 16:07:21 +0100, Rodrigo Campos wrote:
>> Hi Namhyung,
>>
>> Frederic Weisbecker and Arnaldo Carvalho de Melo told me on IRC that you were
>> working to forward-port a patch that adds a new sort order to perf report,
>> SORT_INCLUSIVE.
>>
>> That will be useful for me and I was wondering if you are still working on that
>> or if there is a newer version than v6:
>>
>>       http://thread.gmane.org/gmane.linux.kernel.perf.user/882
>>
>>
>> Maybe you have a newer version of it not sent to the list ? Or do you plan to
>> work on it anytime soon ?
>>
>> If there is any branch to test, please let me know :)
>
> Yes I have a patch series for that.  But it's not a new sort order but a
> new command line option --culumate.  I don't think it should be a new
> sort order since it affects only how it counts period value on each
> sample not how samples are sorted/grouped.
>
> It's about a year since I sent this series to list.  I'll work on it and
> send it to the list soon.

Thanks a lot!

>  But before that I have to re-read what's the
> Frederic's concern - IIRC it's about consolidating code in perf report
> that does similar things on branch stack.
>
> Frederic, can you remember what was the problem?
>
> Anyway, You can find the series and discussion on the link below:
>
>   https://lkml.org/lkml/2012/9/13/81

Right so my concern was that it should be an extension of "perf report
- b" rather than an ad-hoc. Cumulative callchains is basically what
perf report -b does but with callchains. And since callchains are
branches, this should be a perfect fit.

Also I don't remember if perf report -b adds branches to the hist with
a period of 1 of with the period of the referring event. I remember
there was an issue a long time ago there. May be it was fixed. Anyway
IMO the period of 1 doesn't make sense, branches should be added with
the period of the event.

Thanks.
