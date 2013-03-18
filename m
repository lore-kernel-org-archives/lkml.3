Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3CROmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:42:54 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:41726 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3CROmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:42:52 -0400
Date: Mon, 18 Mar 2013 11:42:43 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/2] perf tests: Add a test case for checking sw clock
 event frequency
Message-ID: <20130318144243.GA3351@ghostprotocols.net>
References: <1363574507-18808-1-git-send-email-namhyung@kernel.org>
 <1363574507-18808-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363574507-18808-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 18, 2013 at 11:41:47AM +0900, Namhyung Kim escreveu:
> +static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
> +{
> +	int i, err = -1;
> +	volatile int tmp = 0;
> +	u64 total_periods = 0;
> +	int nr_samples = 0;
> +	union perf_event *event;
> +	struct perf_evsel *evsel;
> +	struct perf_evlist *evlist;
> +	struct perf_event_attr attr = {
> +		.type = PERF_TYPE_SOFTWARE,
> +		.config = clock_id,
> +		.sample_type = PERF_SAMPLE_PERIOD,
> +		.exclude_kernel = 1,
> +		.disabled = 1,
> +		.freq = 1,
> +		.sample_freq = 10000,
> +	};

In some compilers we get:

tests/sw-clock.c: In function ‘__test__sw_clock_freq’:
tests/sw-clock.c:35: error: unknown field ‘sample_freq’ specified in initializer

So I'm moving the initialization to outside the struct named initialization block, i.e.:

@@ -32,9 +32,10 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
                .exclude_kernel = 1,
                .disabled = 1,
                .freq = 1,
-               .sample_freq = 10000,
        };
 
+       attr.sample_freq = 10000;
+

- Arnaldo
