Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3CSFKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:10:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54354 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab3CSFKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:10:37 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-74-5147f34bda64
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/2] perf tests: Add a test case for checking sw clock event frequency
References: <1363574507-18808-1-git-send-email-namhyung@kernel.org>
	<1363574507-18808-2-git-send-email-namhyung@kernel.org>
	<20130318144243.GA3351@ghostprotocols.net>
Date: Tue, 19 Mar 2013 14:10:35 +0900
In-Reply-To: <20130318144243.GA3351@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 18 Mar 2013 11:42:43 -0300")
Message-ID: <87y5dkht4k.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 18 Mar 2013 11:42:43 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Mar 18, 2013 at 11:41:47AM +0900, Namhyung Kim escreveu:
>> +static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
>> +{
>> +	int i, err = -1;
>> +	volatile int tmp = 0;
>> +	u64 total_periods = 0;
>> +	int nr_samples = 0;
>> +	union perf_event *event;
>> +	struct perf_evsel *evsel;
>> +	struct perf_evlist *evlist;
>> +	struct perf_event_attr attr = {
>> +		.type = PERF_TYPE_SOFTWARE,
>> +		.config = clock_id,
>> +		.sample_type = PERF_SAMPLE_PERIOD,
>> +		.exclude_kernel = 1,
>> +		.disabled = 1,
>> +		.freq = 1,
>> +		.sample_freq = 10000,
>> +	};
>
> In some compilers we get:
>
> tests/sw-clock.c: In function ‘__test__sw_clock_freq’:
> tests/sw-clock.c:35: error: unknown field ‘sample_freq’ specified in initializer
>
> So I'm moving the initialization to outside the struct named initialization block, i.e.:
>
> @@ -32,9 +32,10 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
>                 .exclude_kernel = 1,
>                 .disabled = 1,
>                 .freq = 1,
> -               .sample_freq = 10000,
>         };
>  
> +       attr.sample_freq = 10000;
> +
>

Thanks for fixing this!
Namhyung
