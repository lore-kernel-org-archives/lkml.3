Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaG2NZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:25:05 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:62097 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaG2NZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:25:04 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2014 09:25:04 EDT
MIME-Version: 1.0
In-Reply-To: <20140729014343.GE5203@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com> <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
 <20140727173616.GA22986@intel.com> <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
 <20140729014343.GE5203@intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 29 Jul 2014 15:17:29 +0200
Message-ID: <CAKfTPtAj1sye899ac5eMwgrHOLbGmrQhmRK5xEF3s2W6y0BReQ@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average tracking
To: Yuyang Du <yuyang.du@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2014 03:43, Yuyang Du <yuyang.du@intel.com> wrote:
> On Tue, Jul 29, 2014 at 11:12:37AM +0200, Vincent Guittot wrote:
>> >>
>> >> Do you really need to have *w for computing the load_sum ? can't you
>> >> only use it when computing the load_avg ?
>> >>
>> >> sa->load_avg = div_u64(sa->load_sum * w , LOAD_AVG_MAX)
>> >>
>> >
>> > For task, assuming its load.weight does not change much, yes, we can. But in theory, task's
>>
>> I would even say that the load_avg of a task should not be impacted by
>> an old priority value. Once, the priority of a task is changed, we
>> should only take into account this new priority to weight the load_avg
>> of the task
>>
>> > load.weight can change, and *w in load_sum can take into that change. For group entity
>> > and cfs_rq, its load.weight changes all the time, I don't know how to do it without *w
>> > for load_sum.
>>
>> IMHO, we should apply the same policy than the one i mentioned for
>> task. So the load_avg of an entity or a cfs_rq will not be disturbed
>> by an old but no more valid weight
>>
>
> Well, I see your point. But the problem is what matters is load_avg vs. load_avg, not a
> load_avg itself. So, if load_avg1 discards old weight if weight is changed, but load_avg2
> has no weight changed or has weight changed, the comparison load_avg1 vs. load_avg2 is not
> fair, but too impacted by the new weight. The point is, we count in history, so connt in the
> real history, which is the whole point of why we count the history. Make sense?

IIUC, you want to soften the impact of weight change on cfs_rq-> load_avg ?

>
> Thanks,
> Yuyang
