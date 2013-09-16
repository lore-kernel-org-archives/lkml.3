Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3IPGSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 02:18:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47570 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab3IPGSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 02:18:48 -0400
Message-ID: <5236A289.2010007@zytor.com>
Date: Mon, 16 Sep 2013 01:17:45 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel: Clean-up/reduce PEBS code
References: <tip-8q6y4davda9aawwv5yxe7klp@git.kernel.org> <87mwng53ki.fsf@tassilo.jf.intel.com> <20130916060736.GN21832@twins.programming.kicks-ass.net>
In-Reply-To: <20130916060736.GN21832@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 01:07 AM, Peter Zijlstra wrote:
> On Fri, Sep 13, 2013 at 11:18:21PM -0700, Andi Kleen wrote:
>> tip-bot for Peter Zijlstra <tipbot@zytor.com> writes:
>>> +
>>> +	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
>>> +	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
>>>
>>>   	ds->pebs_index = ds->pebs_buffer_base;
>>>
>>> +	n = (top - at) / x86_pmu.pebs_record_size;
>>
>>
>> This adds a full slow division to the PEBS hot path.
>>
>> Does not seem like a improvement to me.
>
> There already was an implicit division there, and
> sizeof(pebs_record_hsw) = 176, can it really optimize that constant
> division?
>

gcc can optimize ANY constant division, if nothing else then by 
reciprocal multiplication.

	-hpa


