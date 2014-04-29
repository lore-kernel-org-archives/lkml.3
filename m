Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaD2DOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:14:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53854 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbaD2DOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:14:22 -0400
Message-ID: <535F180C.4090404@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 08:40:04 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Preeti Murthy <preeti.lkml@gmail.com>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Alex Shi <alex.shi@linaro.org>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, aswin@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
References: <1398303035-18255-2-git-send-email-jason.low2@hp.com> <5358E417.8090503@linux.vnet.ibm.com> <20140424120415.GS11096@twins.programming.kicks-ass.net> <20140424124438.GT13658@twins.programming.kicks-ass.net> <1398358417.3509.11.camel@j-VirtualBox> <20140424171453.GZ11096@twins.programming.kicks-ass.net> <5359EDDB.4060409@linux.vnet.ibm.com> <20140425094331.GF26782@laptop.programming.kicks-ass.net> <1398455654.2102.29.camel@j-VirtualBox> <CAM4v1pMj8KqPG3gebA6ykU92fzWhDVCAzw6fUpVGgGNcruDd0A@mail.gmail.com> <20140428092403.GE27561@twins.programming.kicks-ass.net>
In-Reply-To: <20140428092403.GE27561@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042903-5806-0000-0000-000024BFAD08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 02:54 PM, Peter Zijlstra wrote:
> On Sun, Apr 27, 2014 at 02:01:45PM +0530, Preeti Murthy wrote:
>> Hi Jason, Peter,
>>
>> The below patch looks good to me except for one point.
>>
>> In idle_balance() the below code snippet does not look right:
>>
>> - if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
>> - /*
>> - * We are going idle. next_balance may be set based on
>> - * a busy processor. So reset next_balance.
>> - */
>> +out:
>> + /* Move the next balance forward */
>> + if (time_after(this_rq->next_balance, next_balance))
>>   this_rq->next_balance = next_balance;
>> - }
>>
>> By not checking this_rq->next_balance against jiffies,
>> we might end up not updating this parameter when it
>> has expired.
>>
>> So shouldn't it be:
>>
>> if (time_after(jiffies, this_rq->next_balance) ||
>>            time_after(this_rq->next_balance, next_balance))
>>     this_rq->next_balance = next_balance;
> 
> So the reason I didn't do that is that nothing else does that either.
> Also, note that the value we set rq->next_balance to might itself
> already be expired. There is no guarantee that last_balance + interval
> is in the future.
> 
Hmm this makes sense. Thanks!

Regards
Preeti U Murthy

