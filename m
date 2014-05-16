Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaEPG0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:26:21 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45027 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaEPG0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:26:20 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 06/20] perf tools: Consolidate output field handling to hpp format routines
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
	<1399876133-17963-7-git-send-email-namhyung@kernel.org>
	<20140515121152.GB25858@krava.brq.redhat.com>
Date: Fri, 16 May 2014 15:26:15 +0900
In-Reply-To: <20140515121152.GB25858@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 15 May 2014 14:11:52 +0200")
Message-ID: <87egzukznc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 14:11:52 +0200, Jiri Olsa wrote:
> On Mon, May 12, 2014 at 03:28:39PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
>> index 9eccf7f4f367..e6920d124c60 100644
>> --- a/tools/perf/ui/stdio/hist.c
>> +++ b/tools/perf/ui/stdio/hist.c
>> @@ -353,8 +353,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
>>  	if (size == 0 || size > bfsz)
>>  		size = hpp.size = bfsz;
>>  
>> -	ret = hist_entry__period_snprintf(&hpp, he);
>> -	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
>> +	hist_entry__period_snprintf(&hpp, he);
>
> hm, how about hist_browser__fprintf_entry.. looks like it could

The term 'hist_browser' is for some browsable UI windows like in TUI or
GUI IMHO.  So I think simply call it as hist_entry__snprintf() is better
as you originally suggested.


> use just hist_entry__period_snprintf as well and we could get rid
> hist_entry__sort_snprintf completely

Hmm.. right.  It'll be gone eventually.

Thanks,
Namhyung
