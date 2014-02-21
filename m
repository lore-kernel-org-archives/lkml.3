Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaBUOZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:25:12 -0500
Received: from forward5m.mail.yandex.net ([37.140.138.5]:52034 "EHLO
	forward5m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbaBUOZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:25:10 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20140221134438.ab2d02c4165fa2a6cbd663be@gmail.com>
References: <230991392848160@web13m.yandex.ru>
	<20140221103715.GP9987@twins.programming.kicks-ass.net>
	<128831392982418@web15j.yandex.ru>
	<311621392984565@web3h.yandex.ru> <20140221134438.ab2d02c4165fa2a6cbd663be@gmail.com>
Subject: Re: [RFC] sched/deadline: Prevent rt_time growth to infinity
MIME-Version: 1.0
Message-Id: <3231392992702@web26m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 21 Feb 2014 18:25:02 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



21.02.2014, 16:44, "Juri Lelli" <juri.lelli@gmail.com>:
> On Fri, 21 Feb 2014 16:09:25 +0400
> Kirill Tkhai <tkhai@yandex.ru> wrote:
>
>> š21.02.2014, 15:39, "Kirill Tkhai" <tkhai@yandex.ru>:
>>> š21.02.2014, 14:37, "Peter Zijlstra" <peterz@infradead.org>:
>>>> ššOn Thu, Feb 20, 2014 at 02:16:00AM +0400, Kirill Tkhai wrote:
>>>>> šššSince deadline tasks share rt bandwidth, we must care about
>>>>> šššbandwidth timer set. Otherwise rt_time may grow up to infinity
>>>>> šššin update_curr_dl(), if there are no other available RT tasks
>>>>> šššon top level bandwidth.
>>>>>
>>>>> šššI'm going to decide the problem the way below. Almost untested
>>>>> šššbecause of I skipped almost all of recent patches which haveto be applied from lkml.
>>>>>
>>>>> šššPlease say, if I skipped anything in idea. Maybe better put
>>>>> šššstart_top_rt_bandwidth() into set_curr_task_dl()?
>>>> ššHow about we only increment rt_time when there's an RT bandwidth timer
>>>> ššactive?
>>> šThis case RT and DL may eat all the time:
>>>
>>> š-------------- štime ------------------>
>>> š|RT's working |DL's working|
>>> š----------------------------
>>> š|rt_runtime šš| ššššššššššš|
>>> š----------------------------
>>> š| šššššššrt_period šššššššš|
>>>
>>> šOr at least more, than it's allowed.
>>>
>>> šIt looks like, if we want to limit time of high priority classes
>>> šexecution, we have to set the timer anyway.
>> šOh, above is confusing. Sorry.
>>
>> šI mean one RT task and
>>
>> š----------------- štime -------------------------->
>> š|DL's working ššš|RT's working| |DL's working ššš|
>> š--------------------------------------------------
>> š| ššššššššššššššš|rt_runtime š| | ššššššššššššššš|
>> š--------------------------------------------------
>> š| ššššššššššššššš| ššrt_period š| ššššššššššššššš|
>>
>> šIn this case FAIR receives less ratio, than (rt_period-rt_runtime)/rt_period.
>
> DL tasks won't be allowed to run in this situation, as their bw exceedes
> rt_runtime/rt_period.

Maybe, I don't uderstand. Where does DL control summary (DL+RT) runtime?

RT does not do this too. But it looks like, RT has to do this.

Kirill
