Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbaGNRxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:53:07 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:37609 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbaGNRw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:52:57 -0400
MIME-Version: 1.0
In-Reply-To: <87a98c2wvu.fsf@sejong.aot.lge.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
	<1404857759-25105-5-git-send-email-eranian@google.com>
	<87a98c2wvu.fsf@sejong.aot.lge.com>
Date: Mon, 14 Jul 2014 19:52:57 +0200
Message-ID: <CABPqkBQA5PG5DwV-cjZrf1JTtj_UC_tE6vdsoEyA+TQWSRejQQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] perf record: add new -I option to sample interrupted
 machine state
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:00 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> Hi Stephane,
>
> On Wed,  9 Jul 2014 00:15:59 +0200, Stephane Eranian wrote:
>> Add -I option to capture machine state registers at interrupt.
>
> You need to add it in the Documentation too.
>
I added it for v2.

> Thanks,
> Namhyung
>
>
>>
>> Use perf report -D to display the sampled register values
>> in each sample.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  tools/perf/builtin-record.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>> index 378b85b..17c45f8 100644
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -876,6 +876,8 @@ const struct option record_options[] = {
>>                   "sample transaction flags (special events only)"),
>>       OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
>>                   "use per-thread mmaps"),
>> +     OPT_BOOLEAN('I', "sample-intr-regs", &record.opts.sample_intr_regs,
>> +                 "Sample machine register on interrupt"),
>>       OPT_END()
>>  };
