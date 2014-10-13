Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaJMUyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:54:00 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:47929 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaJMUx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:53:59 -0400
MIME-Version: 1.0
In-Reply-To: <20141013124401.GA5888@krava.redhat.com>
References: <1413146435-22202-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141013124401.GA5888@krava.redhat.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 13 Oct 2014 22:53:37 +0200
Message-ID: <CAFo99gbCnjBN2zDyLNaQzrTzoQdsYMjqrGOL3gyj3MT4EOAywQ@mail.gmail.com>
Subject: Re: [PATCH] tools: perf: util: sort.c: Changed from using strncat to strlcat
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-13 14:44 GMT+02:00 Jiri Olsa <jolsa@redhat.com>:
> On Sun, Oct 12, 2014 at 10:40:35PM +0200, Rickard Strandqvist wrote:
>> Changed from using strncat to strlcat to simplify the code
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  tools/perf/util/sort.c |   12 ++++--------
>>  1 file changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
>> index 14e5a03..6e242f0 100644
>> --- a/tools/perf/util/sort.c
>> +++ b/tools/perf/util/sort.c
>> @@ -759,8 +759,7 @@ static int hist_entry__snoop_snprintf(struct hist_entry *he, char *bf,
>>                                   size_t size, unsigned int width)
>>  {
>>       char out[64];
>> -     size_t sz = sizeof(out) - 1; /* -1 for null termination */
>> -     size_t i, l = 0;
>> +     size_t i;
>>       u64 m = PERF_MEM_SNOOP_NA;
>>
>>       out[0] = '\0';
>> @@ -771,12 +770,9 @@ static int hist_entry__snoop_snprintf(struct hist_entry *he, char *bf,
>>       for (i = 0; m && i < NUM_SNOOP_ACCESS; i++, m >>= 1) {
>>               if (!(m & 0x1))
>>                       continue;
>> -             if (l) {
>> -                     strcat(out, " or ");
>> -                     l += 4;
>> -             }
>> -             strncat(out, snoop_access[i], sz - l);
>> -             l += strlen(snoop_access[i]);
>> +             if (*out != '\0')
>> +                     strlcat(out, " or ", sizeof(out));
>> +             strlcat(out, snoop_access[i], sizeof(out));
>
> I've got compile error..
>
> [jolsa@krava perf]$ make JOBS=1
>   BUILD:   Doing 'make -j1' parallel build
>   CC       perf.o
>   CC       builtin-annotate.o
>   CC       builtin-bench.o
>   CC       bench/sched-messaging.o
>   CC       bench/sched-pipe.o
>   CC       util/sort.o
> util/sort.c: In function ‘hist_entry__snoop_snprintf’:
> util/sort.c:778:4: error: implicit declaration of function ‘strlcat’ [-Werror=implicit-function-declaration]
>     strlcat(out, " or ", sizeof(out));
>     ^
> util/sort.c:778:4: error: nested extern declaration of ‘strlcat’ [-Werror=nested-externs]
> cc1: all warnings being treated as errors
> make[1]: *** [util/sort.o] Error 1
> make: *** [all] Error 2


Hi

Sorry, I saw an improvement without thinking about that tools/ does
not have access to those functions :-(


Kind regards
Rickard Strandqvist
