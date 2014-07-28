Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaG1TUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:20:32 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:38201 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1TUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:20:30 -0400
Date: Mon, 28 Jul 2014 15:20:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Mike Qiu <qiudayu@linux.vnet.ibm.com>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/cpuset.c:1139
Message-ID: <20140728192026.GI7462@htj.dyndns.org>
References: <53CF22F5.6000206@linux.vnet.ibm.com>
 <20140723151220.GD7103@htj.dyndns.org>
 <53D052FC.3070409@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D052FC.3070409@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 08:27:40AM +0800, Li Zefan wrote:
> On 2014/7/23 23:12, Tejun Heo wrote:
> > On Wed, Jul 23, 2014 at 10:50:29AM +0800, Mike Qiu wrote:
> >> commit 734d45130cb ("cpuset: update cs->effective_{cpus, mems} when config
> >> changes") introduce the below warning in my server.
> >>
> >> [   35.652137] ------------[ cut here ]------------
> >> [   35.652141] WARNING: at kernel/cpuset.c:1139
> > 
> > Hah, can you reproduce it?  If so, can you detail how?
> > 
> 
> It's a typo.
> 
> WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
> 	nodes_equal(cp->mems_allowed, cp->effective_mems));
> 
> should be
> 
> WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
> 	!nodes_equal(cp->mems_allowed, cp->effective_mems));

Care to post a patch?

Thanks.

-- 
tejun
