Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaKDLIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:08:35 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48780 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaKDLIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:08:34 -0500
Message-ID: <5458B3A7.7090605@gmail.com>
Date: Tue, 04 Nov 2014 19:08:23 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/fair: fix use stale overloaded status to find busiest
 group
References: <1415079056-8679-1-git-send-email-wanpeng.li@linux.intel.com> <20141104105203.GM3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141104105203.GM3337@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
On 14/11/4 下午6:52, Peter Zijlstra wrote:
> On Tue, Nov 04, 2014 at 01:30:56PM +0800, Wanpeng Li wrote:
>> Commit caeb178c60f4 ("sched/fair: Make update_sd_pick_busiest() return
>> 'true' on a busier sd") makes groups are ranked in the order overloaded >
>> imbalance > other and busiest group is picked according to this order.
>> sgs->group_capacity_factor is used to check if group is overloaded. In
>> the case of the child domain prefers tasks go to siblings first, the
>> sgs->group_capacity_factor will be set lower to one in order to move all
>> the excess tasks away. However, group overloaded status is not updated
>> in the case of sgs->group_capacity_factor be set lower to one which
>> leads to miss find the busiest group. This patch fix it by updating
>> group overloaded status in the case of sg capacity factor is set to
>> one in order to find busiest group accurately.
> You noticed this while going over Vincents patches, right?

Indeed. ;-)

>
> Also, try and introduce some newlines in the changelog, paragraphs of
> 3-5 lines are best.

Ok, I will send a new version tomorrow. ;-)

Regards,
Wanpeng Li

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

