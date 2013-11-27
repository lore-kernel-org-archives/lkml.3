Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3K0Jy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 04:54:27 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58653 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3K0JyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 04:54:23 -0500
MIME-Version: 1.0
In-Reply-To: <20131126113250.GE1267@krava.brq.redhat.com>
References: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
 <1385274025-30282-2-git-send-email-artagnon@gmail.com> <20131126113250.GE1267@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 27 Nov 2013 15:23:41 +0530
Message-ID: <CALkWK0kTYo=cxD1LHE3Qft5fBupYO4pxpm3BLGOcP-yqf_L6xA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] perf diff: don't compute Delta if he->dummy
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
>> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
>> index 3b67ea2..79e0448 100644
>> --- a/tools/perf/builtin-diff.c
>> +++ b/tools/perf/builtin-diff.c
>> @@ -792,6 +792,9 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
>>
>>       switch (idx) {
>>       case PERF_HPP_DIFF__DELTA:
>> +             if (he->dummy)
>> +                     break;
>> +
>
> the reason I disabled the computation for dummy pairs was
> that the number (ratio and weighted diff) would not make much
> sense (to me) without the real pair
>
> but within the dummy delta column we actually see the compared
> file % overheader which is helpfull, even if there's no real pair
> in the baseline

Wait a minute. Doesn't your comment on [3/5] apply here too?
__hpp__entry_global() computes and checks `pair' before calling
hpp__entry_pair(). If he->dummy is set, it means that `he' doesn't
have any pairs: which means that hpp_entry_pair() wouldn't have been
called by __hpp_entry_global() in the first place. So aren't the
he->dummy checks in the RATIO and WEIGHTED_DIFF case redundant?
