Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3C3Afn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 20:35:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:39661 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab3C3Afl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 20:35:41 -0400
Message-ID: <51563336.701@huawei.com>
Date: Sat, 30 Mar 2013 08:35:02 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: take reference before releasing rcu_read_lock
References: <51556CE9.9060000@huawei.com> <5155718A.90108@parallels.com>
In-Reply-To: <5155718A.90108@parallels.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/29 18:48, Glauber Costa wrote:
> On 03/29/2013 02:28 PM, Li Zefan wrote:
>> The memcg is not referenced, so it can be destroyed at anytime right
>> after we exit rcu read section, so it's not safe to access it.
>>
>> To fix this, we call css_tryget() to get a reference while we're still
>> in rcu read section.
>>
>> This also removes a bogus comment above __memcg_create_cache_enqueue().
>>
> Out of curiosity, did you see that happening ?
> 

Just by code inspection. This is not the only place you use RCU in this
wrong way. Remember the last patch I sent? ;)

> Theoretically, the race you describe seem real, and the fix is sound.
> 

