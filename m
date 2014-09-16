Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaIPGOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:14:10 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38193 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaIPGOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:14:08 -0400
Date: Tue, 16 Sep 2014 15:14:01 +0900
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
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
Message-ID: <20140916061401.GD805@mtj.dyndns.org>
References: <1410535618-9601-1-git-send-email-vdavydov@parallels.com>
 <20140912171809.GA24469@dhcp22.suse.cz>
 <20140912175516.GB6298@mtj.dyndns.org>
 <20140915074257.GB11353@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915074257.GB11353@esperanza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vladimir.

On Mon, Sep 15, 2014 at 11:42:57AM +0400, Vladimir Davydov wrote:
> > So, I'd love to see this happen too but I don't think we can do this.
> > People use published interface.  The usages might be utterly one-off
> > and mental but let's please not underestimate the sometimes senseless
> > creativity found in the wild.  We simply can't remove a bunch of
> > control knobs like this.
> 
> We definitely can't remove something properly operating and widely used,
> but kmem limits are not working and never worked properly due to lack of
> kmem shrinkers, and furthermore CONFIG_MEMCG_KMEM, which tcp accounting
> is enabled by, is marked as UNDER DEVELOPMENT.

I don't think marking config options as "UNDER DEVELOPMENT" in its
help documentation means anything.  It's a rather silly thing to do.
Not many people pay much attention to the help texts and once somebody
somewhere enabled the option for a distro, it's as free in the wild as
any other kernel feature and CONFIG_MEMCG_KMEM is enabled by a lot of
distros.  The same goes with the "debug" controller.  It doesn't mean
much that it has "debug" in its name.  Once it's out in the wild,
there will be someone making use of it in some weird way.

If a debug feature has to be in the mainline kernel, the fact that
it's a debug feature must be explicitly chosen in each use.  IOW, gate
it by an unwieldy boot param which makes it painfully clear that it's
enabling an unstable debug feature and print out a loud warning
message about it.

As it currently stands, CONFIG_MEMCG_KMEM is as good as any other
enabled kernel option.  The help text saying that it's experimental
does not mean anything especially when it doesn't even depend on
CONFIG_BROKEN.

So, the argument "the option was explained as experimental in help
text" doesn't fly at all.  We can still try to deprecate it gradually
if the cleanup seems worthwhile; however, with v2 interface pending,
I'm not sure how meaningful that'd be.  We'd have to carry quite a bit
of v1 code around anyway and I'd like to keep v1 interface as static
as possible.  No reason to shake that at this point.

Thanks.

-- 
tejun
