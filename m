Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbaLKTrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:47:35 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55538 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbaLKTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:47:34 -0500
Message-ID: <5489F4D2.3020806@gmail.com>
Date: Thu, 11 Dec 2014 12:47:30 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 4/8] perf data: Add a 'perf' prefix to the generic fields
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org> <1418310749-22267-5-git-send-email-jolsa@kernel.org> <5489E88A.3000801@gmail.com> <5489E937.2050102@linutronix.de>
In-Reply-To: <5489E937.2050102@linutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/14 11:57 AM, Sebastian Andrzej Siewior wrote:
>>>     $ babeltrace ./ctf-data/
>>>     [03:19:13.962131936] (+0.000001935) cycles: { }, { perf_ip =
>>> 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period = 8 }
>>>     [03:19:13.962133732] (+0.000001796) cycles: { }, { perf_ip =
>>> 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period =
>>> 114 }
>>>     ...
>>
>> How is babeltrace showing time-of-day for perf-based data files? Is that
>> tod when the command is run?
>
> CTF needs an a base offset which we set to 0 because we don't have it.
> It then takes the NS timestamp and computes the "time".

so the perf-clock timestamp is converted to hour-min-second-nsec. That 
is even more confusing - for me at least.

By base offset you mean the conversion between perf-clock and realtime? 
What if that information is known (e.g., my tree at 
https://github.com/dsahern/linux as time-of-day support through a klm) - 
what's the ctf function to set the base offset? Can it be changed as a 
file is processed - e.g., tracepoints capturing ntp adjustments?

David
