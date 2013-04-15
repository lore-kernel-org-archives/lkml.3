Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881Ab3DOF3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:29:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40889 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982Ab3DOF3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:29:35 -0400
Date: Mon, 15 Apr 2013 00:29:24 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, vgoyal@redhat.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: force use_hierarchy if sane_behavior
Message-ID: <20130415052923.GA28141@sergelap>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
 <1365808259-31073-5-git-send-email-tj@kernel.org>
 <20130415011336.GF8408@sergelap>
 <20130415023935.GE3050@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415023935.GE3050@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> Hello, Serge.
> 
> On Sun, Apr 14, 2013 at 08:13:36PM -0500, Serge Hallyn wrote:
> > If I do
> > 
> > 	cd /sys/fs/cgroup/memory
> > 	mkdir b
> > 	cd b
> > 	echo 1 > memory.use_hierarchy
> > 	echo 5000 > memory.limit_in_bytes
> > 	cat memory.limit_in_bytes
> > 8192
> > 	mkdir c
> > 	cd c
> > 	cat memory.use_hierarchy
> > 1
> > 	cat memory.limit_in_bytes
> > 9223372036854775807
> > 	echo $$ > tasks
> > 	bash
> > <killed>
> > 
> > So it seems the hierarchy is being enforced, but not reported in
> > child limit_in_bytes files.
> 
> Hmm.... if I understand you correctly, it ain't bug.  It's supposed to
> work that way.  The parent has certain limits and the child doesn't.
> The child will operate within the paren't limits but in those limits
> it isn't restricted.  We actually have a controller which does
> propagate configuration, the device security one, which I don't think
> is really optimal but it seems to be the easier way to implement
> hierarchical behavior for that controller.
> 
> Anyways, if you think about the use cases, the current memcg way makes
> a lot more sense and is more flexible.  e.g. You can express things
> like A + B shouldn't go above 1000 (whatever the unit is) but A and B
> in each can go upto 700 when there's room.

True, that makes sense, thanks.

This example would be great to have in Documentation/cgroups/memory.txt.
Perhaps as a new subsection 6.2?

-serge
