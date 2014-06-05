Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaFEQKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:10:25 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaFEQKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:10:23 -0400
Message-ID: <53909669.8000007@nod.at>
Date: Thu, 05 Jun 2014 18:10:17 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        vdavydov@parallels.com, tj@kernel.org, handai.szj@taobao.com,
        rientjes@google.com, rusty@rustcorp.com.au,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
References: <1401976841-3899-1-git-send-email-richard@nod.at> <1401976841-3899-2-git-send-email-richard@nod.at> <20140605141841.GA23796@redhat.com> <539090F1.7090408@nod.at> <20140605160029.GA28812@redhat.com>
In-Reply-To: <20140605160029.GA28812@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.06.2014 18:00, schrieb Oleg Nesterov:
> On 06/05, Richard Weinberger wrote:
>>
>> Am 05.06.2014 16:18, schrieb Oleg Nesterov:
>>> On 06/05, Richard Weinberger wrote:
>>>>
>>>> +int mem_cgroup_has_listeners(struct mem_cgroup *memcg)
>>>> +{
>>>> +	int ret = 0;
>>>> +
>>>> +	if (!memcg)
>>>> +		goto out;
>>>> +
>>>> +	spin_lock(&memcg_oom_lock);
>>>> +	ret = !list_empty(&memcg->oom_notify);
>>>> +	spin_unlock(&memcg_oom_lock);
>>>> +
>>>> +out:
>>>> +	return ret;
>>>> +}
>>>
>>> Do we really need memcg_oom_lock to check list_empty() ? With or without
>>> this lock we can race with list_add/del anyway, and I guess we do not care.
>>
>> Hmm, in mm/memcontrol.c all list_dev/add are under memcg_oom_lock.
> 
> And? How this lock can help to check list_empty() ?
> 
> list_add/del can come right after mem_cgroup_has_listeners() and change
> the value of list_empty() anyway.

Ahh, now I can follow your mind. :)

Thanks,
//richard
