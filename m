Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbaJUPBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:01:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:41623 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753295AbaJUPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:01:15 -0400
Date: Tue, 21 Oct 2014 10:58:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141021145809.GA799@home.goodmis.org>
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 01:09:04PM +0200, Jiri Kosina wrote:
> Hi,
> 
> I am seeing the lockdep report below when resuming from suspend-to-disk 
> with current Linus' tree (c2661b80609).
> 
> The reason for CCing Ingo and Peter is that I can't make any sense of one 
> of the stacktraces lockdep is providing.
> 
> Please have a look at the very first stacktrace in the dump, where lockdep 
> is trying to explain where cpu_hotplug.lock#2 has been acquired. It seems 
> to imply that cpuidle_pause() is taking cpu_hotplug.lock, but that's not 
> the case at all.
> 
> What am I missing?
> 


> 
> -> #1 (cpu_hotplug.lock#2){+.+.+.}:
>         [<ffffffff81099fac>] lock_acquire+0xac/0x130
>         [<ffffffff815b9f2c>] mutex_lock_nested+0x5c/0x3b0
>         [<ffffffff81491892>] cpuidle_pause+0x12/0x30
>         [<ffffffff81402314>] dpm_suspend_noirq+0x44/0x340
>         [<ffffffff81402958>] dpm_suspend_end+0x38/0x80
>         [<ffffffff810a07bd>] hibernation_snapshot+0xcd/0x370
>         [<ffffffff810a1248>] hibernate+0x168/0x210
>         [<ffffffff8109e9b4>] state_store+0xe4/0xf0
>         [<ffffffff813003ef>] kobj_attr_store+0xf/0x20
>         [<ffffffff8121e9a3>] sysfs_kf_write+0x43/0x60
>         [<ffffffff8121e287>] kernfs_fop_write+0xe7/0x170
>         [<ffffffff811a7342>] vfs_write+0xb2/0x1f0
>         [<ffffffff811a7da4>] SyS_write+0x44/0xb0
>         [<ffffffff815be856>] system_call_fastpath+0x16/0x1b

Yeah, this backtrace looks totally bogus. Unless there's some magic going on
with grabbing the get_online_cpus here?

Could you send your config. Maybe it has to do with some debug magic?

-- Steve

