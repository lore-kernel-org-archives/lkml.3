Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943Ab3CID3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:29:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62267 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431Ab3CID3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:29:41 -0500
Date: Fri, 8 Mar 2013 19:29:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org
Subject: Re: lockdep trace from prepare_bprm_creds
Message-ID: <20130309032936.GT14556@mtj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
 <20130307180332.GE29601@htj.dyndns.org>
 <20130307191242.GA18265@redhat.com>
 <20130307193820.GB3209@htj.dyndns.org>
 <513A9A67.60909@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A9A67.60909@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Sat, Mar 09, 2013 at 10:11:51AM +0800, Li Zefan wrote:
> On 2013/3/8 3:38, Tejun Heo wrote:
> > On Thu, Mar 07, 2013 at 08:12:42PM +0100, Oleg Nesterov wrote:
> >> Well yes, I agree. I think that perfomance-wise threadgroup_change_begin()
> >> in de_thread() is fine, and perhaps it is even more clean because we are
> >> going to do the thread-group change. The scope of cred_guard_mutex is huge,
> >> it doesn't look very nice in threadgroup_lock().
> >>
> >> But we should avoid the cgroup-specific hooks as much as possible, so I
> >> like your patch more.
> > 
> > I don't really mind how it's done but while my approach seems to limit
> > itself to cgroup proper, threadgroup locking is actually more invasive
> > by meddling with cred_mutex.  As you said, yours is the cleaner and
> > probably more permanent one here.
> > 
> 
> Agreed.
> 
> Now we need that patch to be resent with SOB and proper changelog.

Now that I think more about it, I think I want both patches.  It is
bothering that threadgroup lock is nested inside cgroup_lock.  It
always has.  I just couldn't do anything about that until recently.
Li, can you be persuaded into getting the lock reordering patch into a
useable shape?  :)

Thanks.

-- 
tejun
