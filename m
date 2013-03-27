Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3C0PTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:19:25 -0400
Received: from mx2.parallels.com ([199.115.105.18]:42927 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3C0PTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:19:23 -0400
Message-ID: <51530E1E.3010100@parallels.com>
Date: Wed, 27 Mar 2013 19:19:58 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz> <20130327145727.GD29052@cmpxchg.org> <20130327151104.GK16579@dhcp22.suse.cz>
In-Reply-To: <20130327151104.GK16579@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 07:11 PM, Michal Hocko wrote:
> On Wed 27-03-13 10:58:25, Johannes Weiner wrote:
>> On Wed, Mar 27, 2013 at 09:36:39AM +0100, Michal Hocko wrote:
> [...]
>>> +	/*
>>> +	 * kmem_cache_create_memcg duplicates the given name and
>>> +	 * cgroup_name for this name requires RCU context.
>>> +	 * This static temporary buffer is used to prevent from
>>> +	 * pointless shortliving allocation.
>>> +	 */
>>> +	if (!tmp_name) {
>>> +		tmp_name = kmalloc(PAGE_SIZE, GFP_KERNEL);
>>> +		WARN_ON_ONCE(!tmp_name);
>>
>> Just use the page allocator directly and get a free allocation failure
>> warning. 
> 
> WARN_ON_ONCE is probably pointless.
> 
>> Then again, order-0 pages are considered cheap enough that they never
>> even fail in our current implementation.
>>
>> Which brings me to my other point: why not just a simple single-page
>> allocation?
> 
> No objection from me. I was previously thinking about the "proper"
> size for something that is a file name. So I originally wanted to use
> PATH_MAX instead but ended up with PAGE_SIZE for reasons I do not
> remember now.

theoretically, this is PATH_MAX + max cache name.


