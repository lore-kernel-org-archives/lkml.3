Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaBRCnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:43:01 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:51722 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaBRCm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:42:59 -0500
Message-ID: <5302C8AB.8070401@linux.vnet.ibm.com>
Date: Tue, 18 Feb 2014 10:42:51 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [RFC PATCH] sched: make sure sched-priority after invoke idle_balance()
References: <52FDA18D.40100@linux.vnet.ibm.com> <20140214123845.GI27965@twins.programming.kicks-ass.net> <53018284.5070408@linux.vnet.ibm.com> <20140217112420.GD15586@twins.programming.kicks-ass.net>
In-Reply-To: <20140217112420.GD15586@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021802-9574-0000-0000-00000C009D54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 07:24 PM, Peter Zijlstra wrote:
[snip]
>> Since idle_balance() won't happen in the loop, may be we could use:
>>
>> 	if p && p->sched_class == class
>> 		return p
>>
>> in here, let it fall down into the loop if p is idle, since that means
>> we got RT/DL and will do this anyway, could save two jump work may be?
>> (and may could combine some code below if so?)
> 
> Maybe; we'd have to look at whatever GCC does with it. 

Exactly, alien code appear when in binary...

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

