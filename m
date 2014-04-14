Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaDNSPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:15:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaDNSO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:14:58 -0400
Date: Mon, 14 Apr 2014 14:14:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Message-ID: <20140414181421.GC9552@redhat.com>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
 <20140414154556.GA9552@redhat.com>
 <20140414175236.GB15249@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414175236.GB15249@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 01:52:36PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 14, 2014 at 11:45:56AM -0400, Vivek Goyal wrote:
> > So this patchset does not *enforce* a single hierarchy? So user space
> > can still mount other hierarchies.
> 
> Nope, nothing is forced.  Controllers may be moved between unified and
> traditional multiple hierarchies.

So is this an intermediate mode before we move to single hiearchy *only*
mode. AFAIK, you had mentioned that we will support legacy multiple
hiearchy mode but single hiearchy is the new default mode.

How does one figure out which one is unified hiearchy (out of multiple
hierarchies). Is there a flag somewhere? Or sane flag will be used to
mark unified hiearchy.

> 
> > How does this work for root's tasks now? Given that task can only be
> > in leaf cgroups, that means tasks can't be in / cgroup (If one wants
> > to create some cgroups). Does that mean / will be empty and init system
> > need to setup things right.
> 
> Root is exempt from the restriction.  Root has always been special
> anyway.

So task and child groups can co-exist in root *only*?

> 
> I'll soon post a document describing the design and restrictions of
> unified hierarchy along with an updated version of this patchset.

That would help a lot in understanding various modes and that in
turn will help with patch reviews too.

Thanks
Vivek
