Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3G3CAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:00:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:2675 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3G3CAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:00:19 -0400
Message-ID: <51F71DE2.4020102@huawei.com>
Date: Tue, 30 Jul 2013 09:58:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <cgroups@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kent.overstreet@gmail.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: memcg creates an unkillable task in 3.2-rc2
References: <20130723174711.GE21100@mtj.dyndns.org> <8761vui4cr.fsf@xmission.com> <20130729075939.GA4678@dhcp22.suse.cz> <87ehahg312.fsf@xmission.com> <20130729095109.GB4678@dhcp22.suse.cz> <20130729161026.GD22605@mtj.dyndns.org> <87r4eh70yg.fsf@xmission.com>
In-Reply-To: <87r4eh70yg.fsf@xmission.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am also seeing what looks like a leak somewhere in the cgroup code as
> well.  After some runs of the same reproducer I get into a state where
> after everything is clean up.  All of the control groups have been
> removed and the cgroup filesystem is unmounted, I can mount a cgroup
> filesystem with that same combindation of subsystems, but I can't mount
> a cgroup filesystem with any of those subsystems in any other
> combination.  So I am guessing that the superblock is from the original
> mounting is still lingering for some reason.
> 

If this happens again, you can check /proc/cgroups, 

#subsys_name    hierarchy       num_cgroups     enabled
cpuset  0       1       1
debug   0       1       1
cpu     0       1       1
cpuacct 0       1       1
memory  0       1       1
devices 0       1       1
freezer 0       1       1
blkio   0       1       1

If "hierachy" is not 0, then it didn't really unmounted. If "num_cgroups"
is not 1, then there're some cgroups not really destroyed though they've
been rmdired.

