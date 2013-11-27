Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3K0JdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 04:33:21 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53018 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3K0JdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 04:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <20131126114228.GF1267@krava.brq.redhat.com>
References: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
 <1385274025-30282-3-git-send-email-artagnon@gmail.com> <20131126114228.GF1267@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 27 Nov 2013 15:02:36 +0530
Message-ID: <CALkWK0m7GaJMOpNom2zxG+3SU-FN3G1NPAaNVpUsqFpOCkEC2A@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] perf diff: color the Delta column
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
>> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
>> index 79e0448..84d5f2d 100644
>> --- a/tools/perf/builtin-diff.c
>> +++ b/tools/perf/builtin-diff.c
>> @@ -769,6 +769,33 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
>>       return ret;
>>  }
>>
>> +static int hpp__color_delta(struct perf_hpp_fmt *fmt,
>> +                     struct perf_hpp *hpp, struct hist_entry *he)
>> +{
>> +     struct diff_hpp_fmt *dfmt =
>> +             container_of(fmt, struct diff_hpp_fmt, fmt);
>> +     struct hist_entry *pair = get_pair_fmt(he, dfmt);
>> +     double percent;
>> +     char pfmt[20] = " ";
>> +
>> +     if (!pair)
>> +             goto dummy_print;
>
> same comment here ^^^ as for previous patch

Hm? The comment on the previous patch pertained to printing the delta
if he->dummy was set (ie. if `he' doesn't have any pairs). This
statement is analogous to the logic in __hpp__entry_global(): if
(!pair), then the next line checking pair->diff.computed will segfault
without this check.
