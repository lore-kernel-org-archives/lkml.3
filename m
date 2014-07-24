Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbaGXPwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:52:19 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:40259 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbaGXPwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:52:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140724124748.GB7652@krava.brq.redhat.com>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
 <1404883694-5342-5-git-send-email-namhyung@kernel.org> <20140724124748.GB7652@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 25 Jul 2014 00:51:56 +0900
X-Google-Sender-Auth: 7FLEEo7l4E2n6j1JgXzshSxDFwc
Message-ID: <CAM9d7ch56Otv0T-AxL9yyDhhvyHdHtAw+Q=ZwDLyH0kvjE5-Yw@mail.gmail.com>
Subject: Re: [PATCH 4/6] perf report: Honor column width setting
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 9:47 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Jul 09, 2014 at 02:28:12PM +0900, Namhyung Kim wrote:
>> Set column width and do not change it if user gives -w/--column-widths
>> option.  It'll truncate longer symbols than the width if exists.
>
> SNIP
>
>>
>>  static inline void advance_hpp(struct perf_hpp *hpp, int inc)
>>  {
>> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
>> index 396b0094943d..f89714329c0f 100644
>> --- a/tools/perf/util/sort.c
>> +++ b/tools/perf/util/sort.c
>> @@ -70,7 +70,9 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
>>                                      size_t size, unsigned int width)
>>  {
>>       const char *comm = thread__comm_str(he->thread);
>> -     return repsep_snprintf(bf, size, "%-*s:%5d", width - 6,
>> +
>> +     width = max(7U, width) - 6;
>> +     return repsep_snprintf(bf, size, "%-*.*s:%5d", width, width,
>>                              comm ?: "", he->thread->tid);
>
> I couldn't found what your format string:
>   "%-*.*s:%5d", width, width
>
> is supposed to do... it gives me the same result as for:
>   "%-*s:%5d", width
>
> you use it on more places so I guess it's not a typo ;-)

Yep, it's NOT a typo.  The second * is necessary for limiting maximum
length of printed string - without it we cannot control column
alignment of long symbols.

Thanks,
Namhyung
