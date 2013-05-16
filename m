Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3EPIuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:50:24 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52600 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3EPIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:50:21 -0400
X-AuditID: 9c93017e-b7c8fae000000f00-3f-51949dcb104b
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC/PATCH 1/2] perf script: Add --time-filter option
References: <1368609839-19899-1-git-send-email-namhyung@kernel.org>
	<5193A6E7.9040501@gmail.com> <87sj1n4rh3.fsf@sejong.aot.lge.com>
	<51944796.7020505@gmail.com>
Date: Thu, 16 May 2013 17:50:18 +0900
In-Reply-To: <51944796.7020505@gmail.com> (David Ahern's message of "Wed, 15
	May 2013 20:42:30 -0600")
Message-ID: <8738tn48c5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 15 May 2013 20:42:30 -0600, David Ahern wrote:
> On 5/15/13 7:56 PM, Namhyung Kim wrote:
>>> How about just --time? less typing.
>>
>> Thanks, I'm fine with '--time' too but '--time-filter' looks more
>
> yes, I just have really long command lines now. Is there a consistent
> single letter (X?)?

Do you mean a single-letter option "-X" for this?

>
>> obvious.  What does the timehist command do, btw? ;)
>
> task scheduling time history including run time and time between
> sched-in. It needs to be updated to use tracepoints and perhaps fold
> into perf-sched (e.g., perf sched history). Too many features; too
> little time. I hope to get to it in the next month or so.

Looks useful.

>
>>> I would expect parse_nsec_time to fail. e.g., a time string like 123455.a
>>
>> It looks like current strtol() returns 0 when failed to parse like
>> above.  Hmm.. do I have to check whether the return value is 0 or just
>> ignore invalid inputs?
>
> end will point to the next character not converted so make sure it is
> as expected (*end == '\0').

Arh, okay.  So I'll change it to check the 'end' and fails if an
unexpected input comes.

Thanks,
Namhyung
