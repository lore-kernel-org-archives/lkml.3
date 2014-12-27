Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaL0Fal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 00:30:41 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:59421 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaL0Fak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 00:30:40 -0500
MIME-Version: 1.0
In-Reply-To: <549D8D39.6040000@gmail.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-4-git-send-email-namhyung@kernel.org> <549D8D39.6040000@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 27 Dec 2014 14:30:15 +0900
X-Google-Sender-Auth: Xn-7J9i_e-WFvTsvD5pG0UnllSI
Message-ID: <CAM9d7cj0F5byNdA1JzbzVmWAgJDM-8987BNsCCYy2B=B7QsLNg@mail.gmail.com>
Subject: Re: [PATCH 03/37] perf tools: Use perf_data_file__fd() consistently
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 1:30 AM, David Ahern <dsahern@gmail.com> wrote:
> On 12/24/14 12:14 AM, Namhyung Kim wrote:
>
>> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
>> index 84df2deed988..d8b13407594d 100644
>> --- a/tools/perf/builtin-inject.c
>> +++ b/tools/perf/builtin-inject.c
>> @@ -375,8 +375,10 @@ static int __cmd_inject(struct perf_inject *inject)
>>                 }
>>         }
>>
>
> How about a local variable to make this more readable?
> fd = perf_data_file__fd(file_out)

Will do.


>
>> -       if (!file_out->is_pipe)
>> -               lseek(file_out->fd, session->header.data_offset,
>> SEEK_SET);
>> +       if (!file_out->is_pipe) {
>> +               lseek(perf_data_file__fd(file_out),
>> session->header.data_offset,
>> +                     SEEK_SET);
>> +       }
>>
>>         ret = perf_session__process_events(session, &inject->tool);
>>
>> @@ -385,7 +387,8 @@ static int __cmd_inject(struct perf_inject *inject)
>>                         perf_header__set_feat(&session->header,
>>                                               HEADER_BUILD_ID);
>>                 session->header.data_size = inject->bytes_written;
>> -               perf_session__write_header(session, session->evlist,
>> file_out->fd, true);
>> +               perf_session__write_header(session, session->evlist,
>> +                                          perf_data_file__fd(file_out),
>> true);
>>         }
>>
>>         return ret;
>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>> index aa5fa6aabb31..054c6e57d3b9 100644
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -196,7 +196,7 @@ static int process_buildids(struct record *rec)
>>         struct perf_session *session = rec->session;
>>         u64 start = session->header.data_offset;
>>
>> -       u64 size = lseek(file->fd, 0, SEEK_CUR);
>> +       u64 size = lseek(perf_data_file__fd(file), 0, SEEK_CUR);
>>         if (size == 0)
>>                 return 0;
>>
>> @@ -360,12 +360,12 @@ static int __cmd_record(struct record *rec, int
>> argc, const char **argv)
>>                 perf_header__clear_feat(&session->header,
>> HEADER_GROUP_DESC);
>
>
> Similarly in this function.

No problem.

Thanks,
Namhyung
