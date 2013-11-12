Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3KLIkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:40:55 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57670 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3KLIkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:40:41 -0500
X-AuditID: 9c930197-b7c73ae0000025c6-6d-5281e98782ea
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/10] perf tests: Use lower sample_freq in sw clock event period test
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
	<1384201353-23863-11-git-send-email-acme@infradead.org>
	<5281D3B8.2030104@intel.com>
Date: Tue, 12 Nov 2013 17:40:39 +0900
In-Reply-To: <5281D3B8.2030104@intel.com> (Adrian Hunter's message of "Tue, 12
	Nov 2013 09:07:36 +0200")
Message-ID: <87ob5qui60.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Tue, 12 Nov 2013 09:07:36 +0200, Adrian Hunter wrote:
> On 11/11/13 22:22, Arnaldo Carvalho de Melo wrote:
>> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>>
>> We were using it at 10 kHz, which doesn't work in machines where somehow
>> the max freq was auto reduced by the kernel:
>>
>> [root@ssdandy ~]# perf test 19
>> 19: Test software clock events have valid period values    : FAILED!
>> [root@ssdandy ~]# perf test -v 19
>> 19: Test software clock events have valid period values    :
>> --- start ---
>> Couldn't open evlist: Invalid argument
>> ---- end ----
>> Test software clock events have valid period values: FAILED!
>> [root@ssdandy ~]#
>>
>> [root@ssdandy ~]# cat /proc/sys/kernel/perf_event_max_sample_rate
>> 7000
>>
>> Reducing it to 500 Hz should be good enough for this test and also
>> shouldn't affect what it is testing.
>>
>> But warn the user if it fails, informing the knob and the freq tried.
>
> Doesn't work for me:
>
> ./perf test -v 19
> 19: Test software clock events have valid period values    :
> --- start ---
> mmap size 528384B
> mmap size 528384B
> All (0) samples have period value of 1!
> ---- end ----
> Test software clock events have valid period values: FAILED!
>
> But this fixes it:
>
> diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
> index 93a7139..6664a7c 100644
> --- a/tools/perf/tests/sw-clock.c
> +++ b/tools/perf/tests/sw-clock.c
> @@ -9,7 +9,7 @@
>  #include "util/cpumap.h"
>  #include "util/thread_map.h"
>  
> -#define NR_LOOPS  1000000
> +#define NR_LOOPS  10000000

Or else, why not using the max_sample_rate as the freq value?

Thanks,
Namhyung
