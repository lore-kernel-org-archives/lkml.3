Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab3CGTds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:33:48 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38382 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab3CGTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:33:47 -0500
Date: Thu, 7 Mar 2013 11:33:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: lockdep trace from prepare_bprm_creds
Message-ID: <20130307193342.GA3209@htj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
 <20130307182140.GF29601@htj.dyndns.org>
 <20130307183213.GA18022@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307183213.GA18022@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 07:32:14PM +0100, Oleg Nesterov wrote:
> On 03/07, Tejun Heo wrote:
> >
> > On Thu, Mar 07, 2013 at 10:01:39AM -0800, Tejun Heo wrote:
> > >
> > > Another possibility is moving cgroup_lock outside threadgroup_lock(),
> > > which was impossible before because of cgroup_lock abuses in specific
> > > controller implementations but most of that have been updated and we
> > > should now be pretty close to being able to make cgroup_lock outer to
> > > most other locks.  Appending a completely untested patch below.
> >
> > This probably doesn't help as the dependency involves i_mutex.
> 
> Confused... why?

Maybe I'm confused.  We still have i_mutex -> cgroup_lock from the
mount path.  The original deadlock was cred_mutex -> i_mutex
vs. i_mutex -> cgroup_mutex -> cred_mutex.  The patch changes the
latter to i_mutex -> cgroup_mutex and cred_mutex -> cgroup_mutex.
Gosh, it's confusing, yeah, we might be okay.

-- 
tejun
