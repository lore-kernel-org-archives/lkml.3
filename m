Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3EPCmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 22:42:37 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42412 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3EPCme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 22:42:34 -0400
Message-ID: <51944796.7020505@gmail.com>
Date: Wed, 15 May 2013 20:42:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC/PATCH 1/2] perf script: Add --time-filter option
References: <1368609839-19899-1-git-send-email-namhyung@kernel.org> <5193A6E7.9040501@gmail.com> <87sj1n4rh3.fsf@sejong.aot.lge.com>
In-Reply-To: <87sj1n4rh3.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/13 7:56 PM, Namhyung Kim wrote:
>> How about just --time? less typing.
>
> Thanks, I'm fine with '--time' too but '--time-filter' looks more

yes, I just have really long command lines now. Is there a consistent 
single letter (X?)?

> obvious.  What does the timehist command do, btw? ;)

task scheduling time history including run time and time between 
sched-in. It needs to be updated to use tracepoints and perhaps fold 
into perf-sched (e.g., perf sched history). Too many features; too 
little time. I hope to get to it in the next month or so.


>> I would expect parse_nsec_time to fail. e.g., a time string like 123455.a
>
> It looks like current strtol() returns 0 when failed to parse like
> above.  Hmm.. do I have to check whether the return value is 0 or just
> ignore invalid inputs?

end will point to the next character not converted so make sure it is as 
expected (*end == '\0').

David
