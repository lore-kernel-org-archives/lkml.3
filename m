Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab3G2SOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:14:09 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51275 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab3G2SOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:14:08 -0400
Date: Mon, 29 Jul 2013 14:13:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@gmail.com>
Subject: Re: memcg creates an unkillable task in 3.2-rc2
Message-ID: <20130729181354.GX715@cmpxchg.org>
References: <20130723174711.GE21100@mtj.dyndns.org>
 <8761vui4cr.fsf@xmission.com>
 <20130729075939.GA4678@dhcp22.suse.cz>
 <87ehahg312.fsf@xmission.com>
 <20130729095109.GB4678@dhcp22.suse.cz>
 <20130729161026.GD22605@mtj.dyndns.org>
 <87r4eh70yg.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4eh70yg.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:03:35AM -0700, Eric W. Biederman wrote:
> Yes.  From the looks of the looks of it the cgroup implementation is
> rather badly borked right now, and definitely not up to the standards of
> the other core pieces of the kernel.  One of the reasons I was rather
> apalled when systemd started using them.  Until the code actually works
> reliably and the races are removed most people's systems would be much
> better off with cgroups compiled out.
> 
> A single unified hierarchy is a really nasty idea for the same set of
> reasons. You have to recompile to disable a controller to see if it that
> controller's bugs are what are causing problems on your production
> system.  Compiles or even just a reboot is a very heavy hammer to ask
> people to use when they are triaging a problem.

That's not how it works.  You can always select which controllers you
want to mount during runtime.  Unified hierarchy only means that there
is one cgroup tree for all mounted controllers, rather than every
controller having its own separate cgroup tree.

If you are like most users and currently mount all controllers in the
same directory so that their cgroup trees overlap and appear to be a
single tree, nothing changes for you.
