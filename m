Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaEWQra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:47:30 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:41448 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaEWQr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:47:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140523070534.GB1074@krava>
References: <1400795916-12613-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140523070534.GB1074@krava>
Date: Fri, 23 May 2014 18:47:29 +0200
Message-ID: <CAFo99ga1jg8EpFARdnAs6vEwg6B7N12rVgS4ZQFSQzv4GJ90dg@mail.gmail.com>
Subject: Re: [PATCH] tools: perf: util: session.c: Cleaning up inconsistent
 NULL checks
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I wrote a patch with many errors in relation to how you want
your patches on 3 of May. Maybe from there.
But good, then this fix is included :)


Best regards
Rickard Strandqvist


2014-05-23 9:05 GMT+02:00 Jiri Olsa <jolsa@redhat.com>:
> On Thu, May 22, 2014 at 11:58:36PM +0200, Rickard Strandqvist wrote:
>> Cleaning up inconsistent NULL checks.
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  tools/perf/util/session.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index 55960f2..8defd80 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -1625,13 +1625,15 @@ out_delete_map:
>>  void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
>>                               bool full)
>>  {
>> -     int fd = perf_data_file__fd(session->file);
>> +     int fd;
>>       struct stat st;
>>       int ret;
>>
>>       if (session == NULL || fp == NULL)
>>               return;
>>
>> +     fd = perf_data_file__fd(session->file);
>> +
>>       ret = fstat(fd, &st);
>>       if (ret == -1)
>>               return;
>> --
>> 1.7.10.4
>>
> hi,
> I merged same patch just a week ago or so ;-)
>
> perf session: Fix possible null pointer dereference in session.c
> commit c5765ece8a050836c6255e1276fc8e0e867078da
> Author: Masanari Iida <standby24x7@gmail.com>
> Date:   Thu May 15 02:13:38 2014 +0900
>
>
> thanks,
> jirka
