Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaEAPqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:46:37 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:47421 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaEAPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:46:34 -0400
Date: Thu, 1 May 2014 11:46:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, nasa4836@gmail.com
Subject: Re: [PATCH 6/6] cgroup, memcg: implement css->id and convert
 css_from_id() to use it
Message-ID: <20140501154630.GG31611@htj.dyndns.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
 <1398373333-1521-7-git-send-email-tj@kernel.org>
 <535DCBFC.4000404@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535DCBFC.4000404@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 11:33:16AM +0800, Li Zefan wrote:
> On 2014/4/25 5:02, Tejun Heo wrote:
> > Until now, cgroup->id has been used to identify all the associated
> > csses and css_from_id() takes cgroup ID and returns the matching css
> > by looking up the cgroup and then dereferencing the css associated
> > with it; however, now that the lifetimes of cgroup and css are
> > separate, this is incorrect and breaks on the unified hierarchy when a
> > controller is disabled and enabled back again before the previous
> > instance is released.
> > 
> > This patch adds css->id which is a subsystem-unique ID and converts
> > css_from_id() to look up by the new css->id instead.  memcg is the
> > only user of css_from_id() and also converted to use css->id instead.
> > 
> 
> netprio_cgroup also needs to be updated.

Why?  Wouldn't it be more natural to tie that to the associated
cgroup's ID rather than the specific css instance.  It's different for
memcg as it involves css refcnts but netprio_cgroup, AFAICS, only uses
it for cgroup identification anyway.

Thanks.

-- 
tejun
