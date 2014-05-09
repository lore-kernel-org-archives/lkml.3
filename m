Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbaEIQbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:31:10 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61586 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaEIQbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:31:07 -0400
Message-ID: <536D02C0.6070408@linaro.org>
Date: Sat, 10 May 2014 00:30:56 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org> <20140424162029.GV11096@twins.programming.kicks-ass.net> <20140429150430.GI2639@e103034-lin>
In-Reply-To: <20140429150430.GI2639@e103034-lin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 4/29/14, 23:04, Morten Rasmussen 写道:
> On Thu, Apr 24, 2014 at 05:20:29PM +0100, Peter Zijlstra wrote:
>> OK, this series is a lot saner, with the exception of 3/8 and
>> dependents.
>>
>> I do still worry a bit for loosing the longer term view for the big
>> domains though. Sadly I don't have any really big machines.
>>
>> I think the entire series is equivalent to setting LB_BIAS to false. So
>> I suppose we could do that for a while and if nobody reports horrible
>> things we could just do this.
>>
>> Anybody?
> I can't say what will happen on big machines, but I think the LB_BIAS
> test could be a way to see what happens. I'm not convinced that it won't
> lead to more task migrations since we will use the instantaneous cpu
> load (weighted_cpuload()) unfiltered.

Reject a simple and partly tested solution because of a untested guess?
Even the old double bias is better in few sceanrios, it doesn't mean it 
is good
in theory.

I don't know the result on big machine too. but imbalance_pct of 
sched_domain
is designed for balance bias on different domain level. We should tune 
that instead
of bias on an random long term load.

Before runnable avg introduction, cpu_load idx make sense on history 
load tracking.
With runnable avg, big instant load means tasks had been running for 
long time. so
we already counted the task history.
As to the cpu history load, if it caused by task moving to other cpu, it 
isn't right to
still count their load on old cpu.

> Morten

