Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaBVJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 04:28:16 -0500
Received: from relay.parallels.com ([195.214.232.42]:44832 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaBVJ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 04:28:14 -0500
Message-ID: <53086DA6.4090806@parallels.com>
Date: Sat, 22 Feb 2014 13:28:06 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -mm v3 2/7] memcg, slab: cleanup memcg cache creation
References: <cover.1392879001.git.vdavydov@parallels.com>	<210fa2501be4cbb7f7caf6ca893301f124c92a67.1392879001.git.vdavydov@parallels.com> <20140221161114.3025c658da0429b7ae9d4985@linux-foundation.org>
In-Reply-To: <20140221161114.3025c658da0429b7ae9d4985@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 04:11 AM, Andrew Morton wrote:
> On Thu, 20 Feb 2014 11:22:04 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> This patch cleanups the memcg cache creation path as follows:
>>  - Move memcg cache name creation to a separate function to be called
>>    from kmem_cache_create_memcg(). This allows us to get rid of the
>>    mutex protecting the temporary buffer used for the name formatting,
>>    because the whole cache creation path is protected by the slab_mutex.
>>  - Get rid of memcg_create_kmem_cache(). This function serves as a proxy
>>    to kmem_cache_create_memcg(). After separating the cache name
>>    creation path, it would be reduced to a function call, so let's
>>    inline it.
> This patch makes a huge mess when it hits linux-next's e61734c5
> ("cgroup: remove cgroup->name").  In the vicinity of
> memcg_create_kmem_cache().  That isn't the first mess e61734c5 made :(
>
> I think I got it all fixed up - please check the end result in
> http://ozlabs.org/~akpm/stuff/.

It looks good to me, thank you!
