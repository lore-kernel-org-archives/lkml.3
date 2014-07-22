Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaGVFaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:30:14 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43490 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaGVFaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:30:12 -0400
Message-ID: <53CDF6DD.8070806@hitachi.com>
Date: Tue, 22 Jul 2014 14:30:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 0/3] perf/sdt : Support for SDT markers
References: <20140717054826.19995.61782.stgit@hemant-fedora> <53C903B7.6070905@hitachi.com> <53CAABCB.5080202@linux.vnet.ibm.com> <53CB349E.50609@hitachi.com> <53CD068B.7000504@linux.vnet.ibm.com>
In-Reply-To: <53CD068B.7000504@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/21 21:24), Hemant Kumar wrote:
> 
> On 07/20/2014 08:46 AM, Masami Hiramatsu wrote:
>> (2014/07/20 2:32), Hemant Kumar wrote:
>>>>> [SNIP] 	
>>>>> First, scan the binaries using :
>>>>> # perf list sdt --scan
>>>> At a glance, maybe we'd better have perf sdt-cache as like as perf buildid-cache
>>>> for manage sdt information. what would you think?
>>>>
>>> I agree with you having perf sdt-cache similar to perf buildid-cache.
>>> But I think if the functionality of perf sdt-cache is only to build the
>>> cache, then we can
>>> go with the perf list sdt --scan. Since, "perf list sdt" is used for
>>> other purposes too, it
>>> should be less confusing for the users to just add another option
>>> (--scan) to create/modify
>>> the cache. What do you suggest?
>> I think there may be some other cases, for example adding user local build
>> binary to the cache, or remove/update it locally. :)
>>
>> And also, in user's mental model of perf-list, it doesn't take an "active"
>> action, that always does "passive" action. So adding such "active" scan option
>> will be more confusing.
> 
> Ok, I understand now.
> 
>> But I also think it is OK that if the sdt is never scanned, the perf-list
>> automatically scans in background (without any option) or suggests user
>> to run "perf sdt-cache --scan". (it depends on how long time it may take)
>>
>> To summarize it, I'd like to suggest adding below functions;
>>
>> perf list sdt : shows all cached SDT events
>> perf list sdt <file> : shows SDT events in <file>
>> perf sdt-cache --scan/-s : scans all system binaries/libraries + added files
>> perf sdt-cache --add/-a <file(s)> : add SDT events in <file> to cache
>> perf sdt-cache --remove/-r <file(s)>: remove SDT events in <file> from cache
> 
> Yeah, I agree with the above mentioned functions.
> 
> So, according to this, if perf list sdt <file> can't find the SDT events 
> for that file
> in the SDT cache, should it say "use perf sdt-cache --add <file> to add 
> the SDT
> events for that file to the cache", or silently, should add that file's 
> SDT events
> to SDT cache?

Hmm, it's a good question. Since the SDT events will be used as a normal
events, perf-record may NOT take an option of execfile in where SDT events are.
This means that if the given events are not cached, perf-record always fails.
Thus, I think we have 2 options, one is just removing "perf-list sdt <file>"
support, or another is "perf-list sdt <file>" silently caches the SDT in <file>.

IMHO, at the first version, we'd better just removes "perf-list sdt <file>"
support, since it is very simple model. And if someone asks supporting that,
we can add that afterwords as an enhancement. ;)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


