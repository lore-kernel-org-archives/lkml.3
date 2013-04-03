Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763074Ab3DCJS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:18:56 -0400
Received: from mx2.parallels.com ([199.115.105.18]:40442 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763043Ab3DCJSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:18:54 -0400
Message-ID: <515BF41D.9080300@parallels.com>
Date: Wed, 3 Apr 2013 13:19:25 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 0/7] memcg: make memcg's life cycle the same as cgroup
References: <515BF233.6070308@huawei.com>
In-Reply-To: <515BF233.6070308@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 01:11 PM, Li Zefan wrote:
> The historical reason that memcg didn't use css_get in some cases, is that
> cgroup couldn't be removed if there're still css refs. The situation has
> changed so that rmdir a cgroup will succeed regardless css refs, but won't
> be freed until css refs goes down to 0.
> 
> This is an early post, and it's NOT TESTED. I just want to see if the changes
> are fine in general.
Well, from my PoV, this will in general greatly simplify memcg lifecycle
management.

Indeed, I can remember no other reason for those complications other
than the problem with removing directories. If cgroup no longer have
this limitation, I would much rather see your approach in.

I will look into the patches individually soon

