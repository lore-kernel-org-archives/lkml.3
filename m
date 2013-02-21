Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3BUPoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:44:10 -0500
Received: from mx0.parallels.com ([199.115.104.20]:59142 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3BUPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:44:09 -0500
Message-ID: <512640DE.4050201@parallels.com>
Date: Thu, 21 Feb 2013 19:44:30 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Steffen Michalke <StMichalke@web.de>
Subject: Re: PROBLEM: Crash cgdeleting empty memory cgroups with memory.kmem.limit_in_bytes
 set
References: <1361375371.7786.5.camel@michalke-online.eu> <20130220230019.GJ3570@htj.dyndns.org> <51260390.8010203@parallels.com>
In-Reply-To: <51260390.8010203@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 03:22 PM, Glauber Costa wrote:
> On 02/21/2013 03:00 AM, Tejun Heo wrote:
>> (cc'ing cgroup / memcg people and quoting whole body)
>>
>> Looks like something is going wrong with memcg cache destruction.
>> Glauber, any ideas?  Also, can we please not use names as generic as
>> kmem_cache_destroy_work_func for something specific to memcg?  How
>> about something like memcg_destroy_cache_workfn?
>>
>> Thanks.
> 
> Steffen,
> 
> Is there any chance you could test that using SLAB instead of SLUB?
> I haven't manage to reproduce it yet, but I am working on some theories
> about why this is happening. If I could at least know if this is likely
> a cache problem vs a inner-memcg problem, that would help. The calltrace
> is not incredibly helpful, but it does indicate that the problem happens
> when freeing cache objects.
> 

Update:

I've already reproduced this and determined this is a problem that
plagues slub only, most likely due to initialization of the node caches.
But I still don't know for sure the exact location. Expect a patch by
tomorrow.

