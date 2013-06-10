Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3FJRIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:08:25 -0400
Received: from mail.candelatech.com ([208.74.158.172]:60311 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3FJRIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:08:23 -0400
Message-ID: <51B60803.9020706@candelatech.com>
Date: Mon, 10 Jun 2013 10:08:19 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v3] Fix lockup related to stop_machine being stuck in
 __do_softirq.
References: <1370554189-31432-1-git-send-email-greearb@candelatech.com> <20130606214014.GK5045@htj.dyndns.org>
In-Reply-To: <20130606214014.GK5045@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 02:40 PM, Tejun Heo wrote:
> On Thu, Jun 06, 2013 at 02:29:49PM -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The stop machine logic can lock up if all but one of
>> the migration threads make it through the disable-irq
>> step and the one remaining thread gets stuck in
>> __do_softirq.  The reason __do_softirq can hang is
>> that it has a bail-out based on jiffies timeout, but
>> in the lockup case, jiffies itself is not incremented.
>>
>> To work around this, re-add the max_restart counter in __do_irq
>> and stop processing irqs after 10 restarts.
>>
>> Thanks to Tejun Heo and Rusty Russell and others for
>> helping me track this down.
>>
>> This was introduced in 3.9 by commit:  c10d73671ad30f5469
>> (softirq:  reduce latencies).
>>
>> It may be worth looking into ath9k to see if it has issues with
>> it's irq handler at a later date.
>>
>> The hang stack traces look something like this:
> ...
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
>   Acked-by: Tejun Heo <tj@kernel.org>
>
> Linus, while this doesn't fix the root cause of the problem - softirq
> runaway - I still think this is a worthwhile protection to have.  Ben
> is in the process of finding out why the softirq runaway happens in
> the first place.  We probably want to add Cc: stable@vger.kernel.org
> tag.

This patch does not seem to be in mainline yet.

Do I need to do something else, or just be patient?

Thanks,
Ben

>
> Thanks.
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

