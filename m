Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaBXKOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:14:38 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57891 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaBXKOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:14:36 -0500
Message-ID: <530B1B80.4000307@linux.vnet.ibm.com>
Date: Mon, 24 Feb 2014 18:14:24 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com> <530AD653.3000808@linux.vnet.ibm.com> <20140224071028.GW9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140224071028.GW9987@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022410-5564-0000-0000-00000C2BD427
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 03:10 PM, Peter Zijlstra wrote:
> On Mon, Feb 24, 2014 at 01:19:15PM +0800, Michael wang wrote:
>> Peter, do we accidentally missed this commit?
>>
>> http://git.kernel.org/tip/477af336ba06ef4c32e97892bb0d2027ce30f466
> 
> Ingo dropped it on Saturday because it makes locking_selftest() unhappy.
> 
> That is because we call locking_selftest() way before we're ready to
> call schedule() and guess what it does :-/
> 
> I'm not entirely sure what to do.. ideally I'd shoot locking_selftest in
> the head, but clearly that's not entirely desired either.

...what about move idle_balance() back to it's old position?

pull_rt_task() logical could be after idle_balance() if still no FAIR
and DL, then go into the pick loop, that may could make things more
clean & clear, should we have a try?

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

