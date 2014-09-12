Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaILRzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:55:25 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46730 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaILRzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:55:23 -0400
Date: Sat, 13 Sep 2014 02:55:16 +0900
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@gmail.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH RFC] memcg: revert kmem.tcp accounting
Message-ID: <20140912175516.GB6298@mtj.dyndns.org>
References: <1410535618-9601-1-git-send-email-vdavydov@parallels.com>
 <20140912171809.GA24469@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912171809.GA24469@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Fri, Sep 12, 2014 at 07:18:09PM +0200, Michal Hocko wrote:
> On Fri 12-09-14 19:26:58, Vladimir Davydov wrote:
> > memory.kmem.tcp.limit_in_bytes works as the system-wide tcp_mem sysctl,
> > but per memory cgroup. While the existence of the latter is justified
> > (it prevents the system from becoming unusable due to uncontrolled tcp
> > buffers growth) the reason why we need such a knob in containers isn't
> > clear to me.
> 
> Parallels was the primary driver for this change. I haven't heard of
> anybody using the feature other than Parallels. I also remember there
> was a strong push for this feature before it was merged besides there
> were some complains at the time. I do not remember details (and I am
> one half way gone for the weekend now) so I do not have pointers to
> discussions.
> 
> I would love to get rid of the code and I am pretty sure that networking
> people would love this go even more. I didn't plan to provide kmem.tcp.*
> knobs for the cgroups v2 interface but getting rid of it altogether
> sounds even better. I am just not sure whether some additional users
> grown over time.
> Nevertheless I am really curious. What has changed that Parallels is not
> interested in kmem.tcp anymore?

So, I'd love to see this happen too but I don't think we can do this.
People use published interface.  The usages might be utterly one-off
and mental but let's please not underestimate the sometimes senseless
creativity found in the wild.  We simply can't remove a bunch of
control knobs like this.

Thanks.

-- 
tejun
