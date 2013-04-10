Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936944Ab3DJJiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:38:01 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39829 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3DJJh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:37:59 -0400
Date: Wed, 10 Apr 2013 11:37:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>, paulus@samba.org, acme@ghostprotocols.net,
        eranian@google.com, namhyung.kim@lge.com, lizefan@huawei.com,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] perf, cgroup: implement hierarchy support for
 perf_event controller
Message-ID: <20130410093755.GC24443@gmail.com>
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
 <1365579146.30071.24.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365579146.30071.24.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2013-04-08 at 19:23 -0700, Tejun Heo wrote:
> > perf_event cgroup controller is one of the remaining few with broken
> > hierarchy support.  It turns out it's pretty easy to implement - the
> > only thing necessary is making perf_cgroup_match() return %true also
> > when the cgroup of the current task is a descendant of the event's
> > cgroup.  This patchset implements cgroup_is_descendant() and uses it
> > to implement hierarchy support in perf_event controller.
> > 
> > This patchset contains the following three patches.
> > 
> >  0001-cgroup-make-sure-parent-won-t-be-destroyed-before-it.patch
> >  0002-cgroup-implement-cgroup_is_descendant.patch
> >  0003-perf-make-perf_event-cgroup-hierarchical.patch
> 
> Thanks, looks simple and straight fwd. 
> 
> > Ingo, how should these be routed?
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git perf_event-hierarchy-support
> 
> Ingo typically likes multi-maintainer sets to be pulled from a common
> tree into all relevant maintainer trees so that git merges afterwards
> just-work (tm). But I'll let him expand.

Yeah - at least for larger changes that's a good workflow.

For smaller changes we can pick one or the other tree. Tejun, do these changes 
create any conflicts with the current tip:master tree? If not then you could carry 
these changes in your tree. If there's significant conflicts then it might be 
better to rebase this on top of perf/core and pull them into perf/core. (assuming 
there's no other cgroups prereq patches beyond the ones in this series.)

Thanks,

	Ingo
