Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3AWO0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:26:34 -0500
Received: from mx2.parallels.com ([64.131.90.16]:47683 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab3AWO0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:26:32 -0500
Message-ID: <50FFF328.9070200@parallels.com>
Date: Wed, 23 Jan 2013 18:26:48 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <1357731938-8417-12-git-send-email-glommer@parallels.com> <20130109124220.ad9f1a54.akpm@linux-foundation.org> <50EDDCAA.6070004@parallels.com> <20130109131705.4156ba5c.akpm@linux-foundation.org> <50EDE0AB.1030509@parallels.com>
In-Reply-To: <50EDE0AB.1030509@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 01:27 AM, Glauber Costa wrote:
> On 01/10/2013 01:17 AM, Andrew Morton wrote:
>> On Thu, 10 Jan 2013 01:10:02 +0400
>> Glauber Costa <glommer@parallels.com> wrote:
>>
>>> The main advantage I see in this approach, is that there is way less
>>> data to be written using a header. Although your way works, it means we
>>> will write the strings "nice", "system", etc. #cpu times. Quite a waste.
>>
>> Yes, overhead can be a significant issue with this type of interface. 
>> But we already incurred a massive overhead by using a human-readable
>> ascii interface.  If performance is an issue, perhaps the whole thing
>> should be grafted onto taskstats instead.  Or create a new
>> taskstats-like thing.
> 
> I think this would be a little alienish in the already alien world of
> cgroups.
> 
> However, I was not so much talking about plain performance overhead as
> measurable in miliseconds-to-parse, but rather just alluding to the fact
> that we would be writing the same set of strings multiple times when a
> header would do just fine.
> 
> This is the same method used for instance by slabinfo.
> 
>>
>> btw, a more typical interface would be
>>
>> cat /.../cpu0
>> nice:nn
>> system:nn
>> irq:nn
>>
> 
> Well, yes. But welcome to cgroups: directories have a meaning, so the
> only way to organize stuff is with plain files in the current hierarchy
> is by filling it with files. As many files as we have cpus.
> 
> At this point you are certain to miss all the other files present in the
> directory.
> 
> 
>> - the traditional one-per-line name:value tuples.  But I'd assumed that
>> having a file per CPU would be aawkward.
>>
> Indeed.
> 

Andrew,

Given my arguments above, which interface would you prefer for me to
settle down? I still don't see any problems with the header, specially
given the fact that it exists precisely to allow fields to come and go
if needed.


