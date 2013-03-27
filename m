Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3C0Eer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:34:47 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:44081 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3C0Eep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:34:45 -0400
Message-ID: <5152768B.3020306@linux.vnet.ibm.com>
Date: Wed, 27 Mar 2013 10:03:15 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        corbet@lwn.net
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org> <1364301443.5053.9.camel@laptop>
In-Reply-To: <1364301443.5053.9.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032704-5816-0000-0000-0000074C4FB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 03/26/2013 06:07 PM, Peter Zijlstra wrote:
> On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
>> +static bool is_light_task(struct task_struct *p)
>> +{
>> +       /* A light task runs less than 20% in average */
>> +       return ((p->se.avg.runnable_avg_sum  * 5) <
>> +                       (p->se.avg.runnable_avg_period));
>> +}
> 
> OK, so we have a 'problem' here, we initialize runnable_avg_* to 0, but
> we want to 'assume' a fresh task is fully 'loaded'. IIRC Alex ran into
> this as well.
> 
> PJT, do you have any sane solution for this, I forgot what the result
> of the last discussion was -- was there any?

The conclusion after last discussion between PJT and Alex was that the
load contribution of a fresh task be set to "full" during "__sched_fork()".

task->se.avg.load_avg_contrib = task->se.load.weight during
__sched_fork() is reflected in the latest power aware scheduler patchset
by Alex.

Thanks

Regards
Preeti U Murthy
> 

