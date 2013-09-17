Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3IQADF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 20:03:05 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:55180 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab3IQADA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 20:03:00 -0400
Date: Mon, 16 Sep 2013 20:02:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: azurIt <azurit@pobox.sk>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] improve memcg oom killer robustness v2
Message-ID: <20130917000244.GD3278@cmpxchg.org>
References: <20130911200426.GO856@cmpxchg.org>
 <20130914124831.4DD20346@pobox.sk>
 <20130916134014.GA3674@dhcp22.suse.cz>
 <20130916160119.2E76C2A1@pobox.sk>
 <20130916140607.GC3674@dhcp22.suse.cz>
 <20130916161316.5113F6E7@pobox.sk>
 <20130916145744.GE3674@dhcp22.suse.cz>
 <20130916170543.77F1ECB4@pobox.sk>
 <20130916152548.GF3674@dhcp22.suse.cz>
 <20130916225246.A633145B@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916225246.A633145B@pobox.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 10:52:46PM +0200, azurIt wrote:
> > CC: "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew Morton" <akpm@linux-foundation.org>, "David Rientjes" <rientjes@google.com>, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
> >On Mon 16-09-13 17:05:43, azurIt wrote:
> >> > CC: "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew Morton" <akpm@linux-foundation.org>, "David Rientjes" <rientjes@google.com>, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
> >> >On Mon 16-09-13 16:13:16, azurIt wrote:
> >> >[...]
> >> >> >You can use sysrq+l via serial console to see tasks hogging the CPU or
> >> >> >sysrq+t to see all the existing tasks.
> >> >> 
> >> >> 
> >> >> Doesn't work here, it just prints 'l' resp. 't'.
> >> >
> >> >I am using telnet for accessing my serial consoles exported by
> >> >the multiplicator or KVM and it can send sysrq via ctrl+t (Send
> >> >Break). Check your serial console setup.
> >> 
> >> 
> >> 
> >> I'm using Raritan KVM and i created keyboard macro 'sysrq + l' resp.
> >> 'sysrq + t'. I'm also unable to use it on my local PC. Maybe it needs
> >> to be enabled somehow?
> >
> >Probably yes. echo 1 > /proc/sys/kernel/sysrq should enable all sysrq
> >commands. You can select also some of them (have a look at
> >Documentation/sysrq.txt for more information)
> 
> 
> Now it happens again and i was just looking on the server's
> htop. I'm sure that this time it was only one process (apache)
> running under user account (not root). It was taking about 100% CPU
> (about 100% of one core). I was able to kill it by hand inside htop
> but everything was very slow, server load was immediately on
> 500. I'm sure it must be related to that Johannes kernel patches
> because i'm also using i/o throttling in cgroups via Block IO
> controller so users are unable to create such a huge I/O. I will try
> to take stacks of processes but i'm not able to identify the
> problematic process so i will have to take them from *all* apache
> processes while killing them.

It would be fantastic if you could capture those stacks.  sysrq+t
captures ALL of them in one go and drops them into your syslog.

/proc/<pid>/stack for individual tasks works too.
