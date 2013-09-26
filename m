Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3IZU7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:59:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50066 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3IZU71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:59:27 -0400
Message-ID: <5244A02C.4050700@linaro.org>
Date: Thu, 26 Sep 2013 13:59:24 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] [RFC] seqcount: Add lockdep functionality to seqcount/seqlock
 structures
References: <1380220464-28840-1-git-send-email-john.stultz@linaro.org>	<1380220464-28840-3-git-send-email-john.stultz@linaro.org> <20130926164600.5b91227e@gandalf.local.home>
In-Reply-To: <20130926164600.5b91227e@gandalf.local.home>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 01:46 PM, Steven Rostedt wrote:
> On Thu, 26 Sep 2013 11:34:22 -0700
> John Stultz <john.stultz@linaro.org> wrote:
>
>> @@ -156,10 +214,19 @@ static inline void write_seqcount_begin(seqcount_t *s)
>>  {
>>  	s->sequence++;
>>  	smp_wmb();
>> +	seqcount_acquire(&s->dep_map, 0, 0, _RET_IP_);
>> +}
>> +
>> +static inline void write_seqcount_begin_nested(seqcount_t *s, int subclass)
>> +{
>> +	s->sequence++;
>> +	smp_wmb();
>> +	seqcount_acquire(&s->dep_map, subclass, 0, _RET_IP_);
>>  }
> For more code reuse, I wonder if we should have:
>
> static inline void write_seqcount_begin(seqcount_t *s)
> {
> 	write_seqcount_begine_nested(s, 0);
> }
>
> -- Steve

Good idea! Done.

Thanks for the review!
-john

