Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaJWTcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:32:00 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48341 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaJWTb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:31:59 -0400
Date: Thu, 23 Oct 2014 12:28:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com, oleg@redhat.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023192807.GY4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141013173504.GA27955@redhat.com>
 <20141023183232.GW4977@linux.vnet.ibm.com>
 <20141023184018.GA12274@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023184018.GA12274@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102319-0025-0000-0000-000000D86A0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 02:40:18PM -0400, Dave Jones wrote:
> On Thu, Oct 23, 2014 at 11:32:32AM -0700, Paul E. McKenney wrote:
> 
>  > > trinity-c225    R  running task    13448   646  32295 0x00000000
>  > >  ffff880161ccfb28 0000000000000002 ffff880161ccfe10 ffff88000bf85e00
>  > >  00000000001d4100 0000000000000003 ffff880161ccffd8 00000000001d4100
>  > >  ffff880030124680 ffff88000bf85e00 ffff880161ccffd8 0000000000000000
>  > > Call Trace:
>  > >  [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
>  > >  [<ffffffff8883df10>] retint_kernel+0x20/0x30
>  > >  [<ffffffff88233d41>] ? __d_lookup_rcu+0xd1/0x1e0
>  > >  [<ffffffff88233dd6>] ? __d_lookup_rcu+0x166/0x1e0
>  > >  [<ffffffff88222f9f>] lookup_fast+0x4f/0x3d0
>  > >  [<ffffffff88224857>] link_path_walk+0x1a7/0x8a0
>  > >  [<ffffffff88224f95>] ? path_lookupat+0x45/0x7b0
>  > >  [<ffffffff88224fb7>] path_lookupat+0x67/0x7b0
>  > >  [<ffffffff880d385d>] ? trace_hardirqs_off+0xd/0x10
>  > >  [<ffffffff8883dda4>] ? retint_restore_args+0xe/0xe
>  > >  [<ffffffff8822572b>] filename_lookup+0x2b/0xc0
>  > >  [<ffffffff88229c77>] user_path_at_empty+0x67/0xc0
>  > >  [<ffffffff880d3dbe>] ? put_lock_stats.isra.27+0xe/0x30
>  > >  [<ffffffff880d42a6>] ? lock_release_holdtime.part.28+0xe6/0x160
>  > >  [<ffffffff880b15ad>] ? get_parent_ip+0xd/0x50
>  > >  [<ffffffff88229ce1>] user_path_at+0x11/0x20
>  > >  [<ffffffff8824fac1>] do_utimes+0xd1/0x180
>  > >  [<ffffffff8824fbef>] SyS_utime+0x7f/0xc0
>  > >  [<ffffffff8883d345>] ? tracesys+0x7e/0xe2
>  > >  [<ffffffff8883d3a4>] tracesys+0xdd/0xe2
>  > 
>  > This one will require more looking.  But did you do something like
>  > create a pair of mutually recursive symlinks or something?  ;-)
> 
> I'm not 100% sure, but this may have been on a box that I was running
> tests on NFS. So maybe the server had disappeared with the mount
> still active..
> 
> Just a guess tbh.

Another possibility might be that the box was so overloaded that tasks
were getting preempted for 21 seconds as a matter of course, and sometimes
within RCU read-side critical sections.  Or did the box have ample idle
time?

							Thanx, Paul

