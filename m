Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaDDMEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:04:08 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63949 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaDDMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:04:03 -0400
Date: Fri, 4 Apr 2014 08:03:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
Message-ID: <20140404120359.GA5461@mtj.dyndns.org>
References: <20140403164911.GE24119@htj.dyndns.org>
 <CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
 <CA+55aFwBm202pchEH9A6vbJVdar9-T35pBF44cCt7FNjmno9sQ@mail.gmail.com>
 <CAOS58YMckmoCocguf9BC_Wxbn3D2Rx3MArhgozO9qCj4g=5aDw@mail.gmail.com>
 <CA+55aFw2+VKojzoF2aDaruOMKHikTO8J0HeK9DoDLZr+HqTWbg@mail.gmail.com>
 <20140403194335.GC2472@mtj.dyndns.org>
 <CA+55aFw+jFdmmi6eZ6+RpLM9heyowfXsZxb6Y91GNkPU677PmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+jFdmmi6eZ6+RpLM9heyowfXsZxb6Y91GNkPU677PmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 01:02:45PM -0700, Linus Torvalds wrote:
> > The cgroup_root should be destroyed but it isn't, I think.  We'd need
> > to bump cgroup_root's refcnt only when a new sb is created.  It's
> > kinda ugly.  Hmmm...
> 
> Ok, so I guess we can use that "new_sb_created" thing, and I'll redo
> my merge resolution to reflect that. I do find this incredibly ugly.

I apparently missed the issue and designed the interface without
considering this ugliness.  Maybe kernfs could be made to wrap rather
than providing mount/kill_sb() functions and hide details about sb or
we can simply add fstype->umount() so that there's symmetry; however,
the problem is kernfs-specific and other kernfs users would have
single static backing store and won't need to care about this, so, for
now, I think what it's a ugly but acceptable compromise.

Thanks.

-- 
tejun
