Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3GATCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:02:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60112 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3GATCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:02:33 -0400
Date: Mon, 1 Jul 2013 14:02:22 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aaron Staley <aaron@picloud.com>, containers@lists.linux-foundation.org,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: PROBLEM: Processes writing large files in memory-limited LXC
 container are killed by OOM
Message-ID: <20130701190222.GA10367@sergelap>
References: <CAMcjixYa-mjo5TrxmtBkr0MOf+8r_iSeW5MF4c8nJKdp5m+RPA@mail.gmail.com>
 <20130701180101.GA5460@ac100>
 <20130701184503.GG17812@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701184503.GG17812@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Johannes Weiner (hannes@cmpxchg.org):
> On Mon, Jul 01, 2013 at 01:01:01PM -0500, Serge Hallyn wrote:
> > Quoting Aaron Staley (aaron@picloud.com):
> > > This is better explained here:
> > > http://serverfault.com/questions/516074/why-are-applications-in-a-memory-limited-lxc-container-writing-large-files-to-di
> > > (The
> > > highest-voted answer believes this to be a kernel bug.)
> > 
> > Hi,
> > 
> > in irc it has been suggested that indeed the kernel should be slowing
> > down new page creates while waiting for old page cache entries to be
> > written out to disk, rather than ooming.
> > 
> > With a 3.0.27-1-ac100 kernel, doing dd if=/dev/zero of=xxx bs=1M
> > count=100 is immediately killed.  In contrast, doing the same from a
> > 3.0.8 kernel did the right thing for me.  But I did reproduce your
> > experiment below on ec2 with the same result.
> >
> > So, cc:ing linux-mm in the hopes someone can tell us whether this
> > is expected behavior, known mis-behavior, or an unknown bug.
> 
> It's a known issue that was fixed/improved in e62e384 'memcg: prevent

Ah ok, I see the commit says:

    The solution is far from being ideal - long term solution is memcg aware
    dirty throttling - but it is meant to be a band aid until we have a real
    fix.  We are seeing this happening during nightly backups which are placed

... and ...

    The issue is more visible with slower devices for output.

I'm guessing we see it on ec2 because of slowed fs.

> OOM with too many dirty pages', included in 3.6+.

Is anyone actively working on the long term solution?

thanks,
-serge
