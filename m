Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaILRSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:18:15 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37459 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaILRSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:18:13 -0400
Date: Fri, 12 Sep 2014 19:18:09 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@gmail.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH RFC] memcg: revert kmem.tcp accounting
Message-ID: <20140912171809.GA24469@dhcp22.suse.cz>
References: <1410535618-9601-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410535618-9601-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-09-14 19:26:58, Vladimir Davydov wrote:
> memory.kmem.tcp.limit_in_bytes works as the system-wide tcp_mem sysctl,
> but per memory cgroup. While the existence of the latter is justified
> (it prevents the system from becoming unusable due to uncontrolled tcp
> buffers growth) the reason why we need such a knob in containers isn't
> clear to me.

Parallels was the primary driver for this change. I haven't heard of
anybody using the feature other than Parallels. I also remember there
was a strong push for this feature before it was merged besides there
were some complains at the time. I do not remember details (and I am
one half way gone for the weekend now) so I do not have pointers to
discussions.

I would love to get rid of the code and I am pretty sure that networking
people would love this go even more. I didn't plan to provide kmem.tcp.*
knobs for the cgroups v2 interface but getting rid of it altogether
sounds even better. I am just not sure whether some additional users
grown over time.
Nevertheless I am really curious. What has changed that Parallels is not
interested in kmem.tcp anymore?

[...]

Anyway, more than welcome
Acked-by: Michal Hocko <mhocko@suse.cz>

In case we happened to grow more users, which I hope hasn't happened, we
would need to keep this around at least with the legacy cgroups API.
-- 
Michal Hocko
SUSE Labs
