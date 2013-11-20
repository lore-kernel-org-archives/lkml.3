Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3KTWrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:47:49 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:57735 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3KTWrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:47:46 -0500
Date: Wed, 20 Nov 2013 16:47:37 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Message-ID: <20131120224737.GA12883@sbohrermbp13-local.rgmadvisors.com>
References: <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz>
 <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org>
 <20131115075401.GB9755@mtj.dyndns.org>
 <alpine.LNX.2.00.1311171746160.15789@eggly.anvils>
 <20131118201025.GA2747@sbohrermbp13-local.rgmadvisors.com>
 <528AD316.10001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528AD316.10001@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:55:18AM +0800, Li Zefan wrote:
> > Thanks Tejun and Hugh.  Sorry for my late entry in getting around to
> > testing this fix. On the surface it sounds correct however I'd like to
> > test this on top of 3.10.* since that is what we'll likely be running.
> > I've tried to apply Hugh's patch above on top of 3.10.19 but it
> > appears there are a number of conflicts.  Looking over the changes and
> > my understanding of the problem I believe on 3.10 only the
> > cgroup_free_fn needs to be run in a separate workqueue.  Below is the
> > patch I've applied on top of 3.10.19, which I'm about to start
> > testing.  If it looks like I botched the backport in any way please
> > let me know so I can test a propper fix on top of 3.10.19.
> > 
> 
> You didn't move css free_work to the dedicate wq as Tejun's patch does.
> css free_work won't acquire cgroup_mutex, but when destroying a lot of
> cgroups, we can have a lot of css free_work in the workqueue, so I'd
> suggest you also use cgroup_destroy_wq for it.

Well, I didn't move the css free_work, but I did test the patch I
posted on top of 3.10.19 and I am unable to reproduce the lockup so it
appears my patch was sufficient for 3.10.*.  Hopefully we can get this
fix applied and backported into stable.

Thanks,
Shawn
