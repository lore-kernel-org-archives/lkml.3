Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbaLKUXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:23:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:59812 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481AbaLKUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:23:17 -0500
Message-ID: <5489FD23.6000002@linutronix.de>
Date: Thu, 11 Dec 2014 21:22:59 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 4/8] perf data: Add a 'perf' prefix to the generic fields
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org> <1418310749-22267-5-git-send-email-jolsa@kernel.org> <5489E88A.3000801@gmail.com> <5489E937.2050102@linutronix.de> <5489F4D2.3020806@gmail.com>
In-Reply-To: <5489F4D2.3020806@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 08:47 PM, David Ahern wrote:
> On 12/11/14 11:57 AM, Sebastian Andrzej Siewior wrote:
>>>>     $ babeltrace ./ctf-data/
>>>>     [03:19:13.962131936] (+0.000001935) cycles: { }, { perf_ip =
>>>> 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period
>>>> = 8 }
>>>>     [03:19:13.962133732] (+0.000001796) cycles: { }, { perf_ip =
>>>> 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period =
>>>> 114 }
>>>>     ...
>>>
>>> How is babeltrace showing time-of-day for perf-based data files? Is that
>>> tod when the command is run?
>>
>> CTF needs an a base offset which we set to 0 because we don't have it.
>> It then takes the NS timestamp and computes the "time".
> 
> so the perf-clock timestamp is converted to hour-min-second-nsec. That
> is even more confusing - for me at least.

This is the default view of babeltrace. You can switch it off and see
the timestamp in (base + ns).

> By base offset you mean the conversion between perf-clock and realtime?
yes.

> What if that information is known (e.g., my tree at
> https://github.com/dsahern/linux as time-of-day support through a klm) -
> what's the ctf function to set the base offset? Can it be changed as a
> file is processed - e.g., tracepoints capturing ntp adjustments?

Not sure I can follow here. If I'm not mistaken, the perf-clock starts
at 0 at boot time and is then incremented. If you manage to compute the
offset between perf-clock "0" and current-time at-this point then you
can use this as "base". That means, perf-timestamp + base is the
time+date when this event was captured. This base offset isn't stored
in the perf stream.
If you look at ctf_writer__setup_clock() (patch #3) it sets the offset
I refer to. This offset can be set only once and can't be adjusted.

> David

Sebastian
