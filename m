Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaJVSk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:40:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbaJVSkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:40:24 -0400
Date: Wed, 22 Oct 2014 20:40:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
In-Reply-To: <20141022143728.18d1eb3d@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1410222040080.17725@pobox.suse.cz>
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz> <20141021145809.GA799@home.goodmis.org> <alpine.LNX.2.00.1410211703170.24255@pobox.suse.cz> <20141022143728.18d1eb3d@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Steven Rostedt wrote:

> > > > -> #1 (cpu_hotplug.lock#2){+.+.+.}:
> > > >         [<ffffffff81099fac>] lock_acquire+0xac/0x130
> > > >         [<ffffffff815b9f2c>] mutex_lock_nested+0x5c/0x3b0
> > > >         [<ffffffff81491892>] cpuidle_pause+0x12/0x30
> > > >         [<ffffffff81402314>] dpm_suspend_noirq+0x44/0x340
> > > >         [<ffffffff81402958>] dpm_suspend_end+0x38/0x80
> > > >         [<ffffffff810a07bd>] hibernation_snapshot+0xcd/0x370
> > > >         [<ffffffff810a1248>] hibernate+0x168/0x210
> > > >         [<ffffffff8109e9b4>] state_store+0xe4/0xf0
> > > >         [<ffffffff813003ef>] kobj_attr_store+0xf/0x20
> > > >         [<ffffffff8121e9a3>] sysfs_kf_write+0x43/0x60
> > > >         [<ffffffff8121e287>] kernfs_fop_write+0xe7/0x170
> > > >         [<ffffffff811a7342>] vfs_write+0xb2/0x1f0
> > > >         [<ffffffff811a7da4>] SyS_write+0x44/0xb0
> > > >         [<ffffffff815be856>] system_call_fastpath+0x16/0x1b
> > > 
> > > Yeah, this backtrace looks totally bogus. Unless there's some magic going on
> > > with grabbing the get_online_cpus here?
> > > 
> > > Could you send your config. Maybe it has to do with some debug magic?
> > 
> > .config attached.
> > 
> 
> Can you reproduce this all the time? I tried this config and pm-suspend
> and pm-hibernate, and they both worked fine without a single lockdep
> splat.

Yes, it's 100% reliable for me.

-- 
Jiri Kosina
SUSE Labs
