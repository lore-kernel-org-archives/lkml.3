Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3IBRCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 13:02:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:5505 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab3IBRCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 13:02:50 -0400
X-IronPort-AV: E=Sophos;i="4.89,1008,1367971200"; 
   d="scan'208";a="47382688"
Message-ID: <5224C4B7.6090003@citrix.com>
Date: Mon, 2 Sep 2013 18:02:47 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Jiri Kosina <jkosina@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>, Paul Bolle <pebolle@tiscali.nl>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/trace: Correcting and extending tracepoint
 documentation
References: <1377421194.2737.118@driftwood>
In-Reply-To: <1377421194.2737.118@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not very familiar with the tracing framework, but I will try to 
comment on your questions.

On 25/08/13 09:59, Rob Landley wrote:
> On 08/22/2013 04:49:31 PM, Zoltan Kiss wrote:
>> +#if !defined(_TRACE_SUBSYS_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_SUBSYS_H
>
> But this makes no sense to me: why is it needed? (I.E. why must it be
> block copied into each _user_ of tracepoints?)
This is to prevent header reinclusion, the second condition makes it 
possible to include it again from trace/define_trace.h

>>  #include <linux/tracepoint.h>
>>
>> @@ -48,10 +54,16 @@ DECLARE_TRACE(subsys_eventname,
>>      TP_PROTO(int firstarg, struct task_struct *p),
>>      TP_ARGS(firstarg, p));
>>
>> +#endif /* _TRACE_SUBSYS_H */
>> +
>> +/* This part must be outside protection */
>> +#include <trace/define_trace.h>
>> +
>
> Why? (Both why do you need to #include a header outside a multiple
> inclusion guard, and why is the additional header needed at all in
> _every_ subsystem trace header?)
I see only one inclusion guard here, the one above. define_trace.h 
should take effect at only one place, where CREATE_TRACE_POINTS is 
defined, to create the tracepoints exactly once. However I don't see as 
well why it should be outside protection. Maybe because the intentional 
header reinclusion in it?

Regards,

Zoli

