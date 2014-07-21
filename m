Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaGUMY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:24:57 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48105 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaGUMYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:24:55 -0400
Message-ID: <53CD068B.7000504@linux.vnet.ibm.com>
Date: Mon, 21 Jul 2014 17:54:43 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 0/3] perf/sdt : Support for SDT markers
References: <20140717054826.19995.61782.stgit@hemant-fedora> <53C903B7.6070905@hitachi.com> <53CAABCB.5080202@linux.vnet.ibm.com> <53CB349E.50609@hitachi.com>
In-Reply-To: <53CB349E.50609@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072112-1396-0000-0000-000005450174
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/20/2014 08:46 AM, Masami Hiramatsu wrote:
> (2014/07/20 2:32), Hemant Kumar wrote:
>>>> [SNIP] 	
>>>> First, scan the binaries using :
>>>> # perf list sdt --scan
>>> At a glance, maybe we'd better have perf sdt-cache as like as perf buildid-cache
>>> for manage sdt information. what would you think?
>>>
>> I agree with you having perf sdt-cache similar to perf buildid-cache.
>> But I think if the functionality of perf sdt-cache is only to build the
>> cache, then we can
>> go with the perf list sdt --scan. Since, "perf list sdt" is used for
>> other purposes too, it
>> should be less confusing for the users to just add another option
>> (--scan) to create/modify
>> the cache. What do you suggest?
> I think there may be some other cases, for example adding user local build
> binary to the cache, or remove/update it locally. :)
>
> And also, in user's mental model of perf-list, it doesn't take an "active"
> action, that always does "passive" action. So adding such "active" scan option
> will be more confusing.

Ok, I understand now.

> But I also think it is OK that if the sdt is never scanned, the perf-list
> automatically scans in background (without any option) or suggests user
> to run "perf sdt-cache --scan". (it depends on how long time it may take)
>
> To summarize it, I'd like to suggest adding below functions;
>
> perf list sdt : shows all cached SDT events
> perf list sdt <file> : shows SDT events in <file>
> perf sdt-cache --scan/-s : scans all system binaries/libraries + added files
> perf sdt-cache --add/-a <file(s)> : add SDT events in <file> to cache
> perf sdt-cache --remove/-r <file(s)>: remove SDT events in <file> from cache

Yeah, I agree with the above mentioned functions.

So, according to this, if perf list sdt <file> can't find the SDT events 
for that file
in the SDT cache, should it say "use perf sdt-cache --add <file> to add 
the SDT
events for that file to the cache", or silently, should add that file's 
SDT events
to SDT cache?

> And if perf list can't find sdt-cache, it would suggest to run
> perf sdt-cache --scan or run it silently. :)
>
> [...]

-- 
Thanks,
Hemant Kumar

