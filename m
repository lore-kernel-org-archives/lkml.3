Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaFDWX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:23:58 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47953 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaFDWX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140604222047.GA16855@tassilo.jf.intel.com>
References: <1401918378-3842-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140604222047.GA16855@tassilo.jf.intel.com>
Date: Thu, 5 Jun 2014 00:23:55 +0200
Message-ID: <CAFo99gY_GZg7TY=H_UZBDL3dP2vL6NW-TCvtCDx+voY0uH80AA@mail.gmail.com>
Subject: Re: [PATCH] tools: perf: util: parse-events.c: Cleaning up missing
 null-terminate after strncpy call
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

A little embarrassing, but I actually did not know that there was a
better replacement for strncpy.

Sorry, but I will send a new platch based on strlcpy instead then,
snprintf i slow and unnecessary in this case.

Best regards
Rickard Strandqvist


2014-06-05 0:20 GMT+02:00 Andi Kleen <ak@linux.intel.com>:
> On Wed, Jun 04, 2014 at 11:46:18PM +0200, Rickard Strandqvist wrote:
>> Added a guaranteed null-terminate after call to strncpy.
>>
>> This was partly found using a static code analysis program called cppcheck.
>
> Should just stop using strncpy. strncpy semantics don't make any
> sense at all, and it's inefficient. I would just snprintf here
>
> -Andi
>
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  tools/perf/util/parse-events.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
>> index 1e15df1..fad2976 100644
>> --- a/tools/perf/util/parse-events.c
>> +++ b/tools/perf/util/parse-events.c
>> @@ -1216,8 +1216,10 @@ static void print_symbol_events(const char *event_glob, unsigned type,
>>
>>               if (strlen(syms->alias))
>>                       snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
>> -             else
>> +             else {
>>                       strncpy(name, syms->symbol, MAX_NAME_LEN);
>> +                     name[sizeof(name) - 1] = '\0';
>> +             }
>>
>>               printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
>>
>> --
>> 1.7.10.4
>>
>
> --
> ak@linux.intel.com -- Speaking for myself only
