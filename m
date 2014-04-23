Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaDWExC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 00:53:02 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:34696 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaDWExB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 00:53:01 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/9] perf report: Count number of entries and samples separately
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
	<1398156591-11001-2-git-send-email-namhyung@kernel.org>
	<20140422145103.GG1104@krava.brq.redhat.com>
Date: Wed, 23 Apr 2014 13:52:58 +0900
In-Reply-To: <20140422145103.GG1104@krava.brq.redhat.com> (Jiri Olsa's message
	of "Tue, 22 Apr 2014 16:51:03 +0200")
Message-ID: <87fvl4sl3p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, 22 Apr 2014 16:51:03 +0200, Jiri Olsa wrote:
> On Tue, Apr 22, 2014 at 05:49:43PM +0900, Namhyung Kim wrote:
>> Those stats are counted counted in multiple places so that they can
>> confuse readers of the code.  This is a preparation of later change
>> and do not intend any functional difference.

[SNIP]
>> +	rep->nr_samples++;
>> +	if (he->stat.nr_events == 1) {
>> +		/* count new entries only */
>> +		rep->nr_entries++;
>> +	}
>
> smeels like we could use function for this ^^^
>
> also it took me a while to figure out the reason for the condition,
> maybe there could be more comment about that

Okay, so I changed it like below:

static void report__inc_stats(struct report *rep, struct hist_entry *he)
{
	/*
	 * The @he is either of a newly created one or an existing one
	 * merging current sample.  We only want to count a new one so
	 * checking ->nr_events being 1.
	 */
	if (he->stat.nr_events == 1)
		rep->nr_entries++;
}

This also eliminated the unneeded nr_samples field.

Thanks,
Namhyung
