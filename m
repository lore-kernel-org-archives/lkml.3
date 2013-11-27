Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3K0LDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:03:00 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48770 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3K0LC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:02:59 -0500
MIME-Version: 1.0
In-Reply-To: <CALkWK0k2VEJiYGoE0qn9SBQH9b_+N=N4ADhs6WJQh_JF7kDK5g@mail.gmail.com>
References: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
 <1385274025-30282-4-git-send-email-artagnon@gmail.com> <20131126120123.GH1267@krava.brq.redhat.com>
 <CALkWK0k2VEJiYGoE0qn9SBQH9b_+N=N4ADhs6WJQh_JF7kDK5g@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 27 Nov 2013 16:32:17 +0530
Message-ID: <CALkWK0m4XbJ8FpYEQ8UVtAcgX4mQwsKN9pt1MpX3nZL+A62NQQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] perf diff: generalize hpp__color_delta for -c
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
> Jiri Olsa wrote:
>>>       if (!pair)
>>>               goto dummy_print;
>>>       if (pair->diff.computed)
>>> -             percent = pair->diff.period_ratio_delta;
>>> +             switch (comparison_method) {
>>> +             case COMPUTE_DELTA:
>>> +                     delta = pair->diff.period_ratio_delta;
>>> +                     break;
>>> +             default:
>>> +                     BUG_ON(1);
>>> +             }
>>>       else
>>> -             percent = compute_delta(he, pair);
>>> +             switch (comparison_method) {
>>> +             case COMPUTE_DELTA:
>>> +                     delta = compute_delta(he, pair);
>>> +                     break;
>>> +             default:
>>> +                     BUG_ON(1);
>>> +             }
>>>
>>> -     if (!he->dummy && fabs(percent) >= 0.01) {
>>> -             scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
>>> -             return color_snprintf(hpp->buf, hpp->size,
>>> -                             percent > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
>>> -                             pfmt, percent);
>>> +     if (!he->dummy) {
>>
>> isn't this check superfluous because of the above (!pair) check?
>
> From builtin-diff.c:get_pair_data(), we see that `pair' is one of the
> pairs in he->pairs. he->dummy is set in
> util/hist.c:hists__add_dummy_entry() which is called only when he
> doesn't have pairs (util/hist.c:942).

Sorry about the major thinko: hists__add_dummy_entry() returns a new
`he' with he->dummy set; it has nothing to do with pair->pairs of the
`pair' that it is passed.

I think I understand what's going on: I'll submit a new iteration soon.
