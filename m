Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3DAHXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:23:32 -0400
Received: from mx2.parallels.com ([199.115.105.18]:46412 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab3DAHXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:23:31 -0400
Message-ID: <5159361D.40302@parallels.com>
Date: Mon, 1 Apr 2013 11:24:13 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: take reference before releasing rcu_read_lock
References: <51556CE9.9060000@huawei.com> <5155718A.90108@parallels.com> <51563336.701@huawei.com>
In-Reply-To: <51563336.701@huawei.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 04:35 AM, Li Zefan wrote:
> On 2013/3/29 18:48, Glauber Costa wrote:
>> On 03/29/2013 02:28 PM, Li Zefan wrote:
>>> The memcg is not referenced, so it can be destroyed at anytime right
>>> after we exit rcu read section, so it's not safe to access it.
>>>
>>> To fix this, we call css_tryget() to get a reference while we're still
>>> in rcu read section.
>>>
>>> This also removes a bogus comment above __memcg_create_cache_enqueue().
>>>
>> Out of curiosity, did you see that happening ?
>>
> 
> Just by code inspection. This is not the only place you use RCU in this
> wrong way. Remember the last patch I sent? ;)
> 
Indeed, that is what happens with miscomprehensions: the mistake tends
to be repeated. Thanks for your diligence with this.

