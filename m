Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab3LLPzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:55:39 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:39805 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3LLPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:55:35 -0500
Date: Thu, 12 Dec 2013 10:55:23 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Message-ID: <20131212155523.GF32683@htj.dyndns.org>
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
 <20131212153536.GD32683@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212153536.GD32683@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 10:35:36AM -0500, Tejun Heo wrote:
> On Sat, Dec 07, 2013 at 11:58:05AM +0400, Vladimir Davydov wrote:
> > We should not call cgroup_unload_subsys() if online_css() fails, because
> > online_css() does not assign css to cgroup on failure, while
> > offline_css() called from cgroup_unload_subsys() expects it is assigned.
> > So let's call everything we need to rollback inline without involving
> > cgroup_unload_subsys().
> > 
> > Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Li Zefan <lizefan@huawei.com>
> 
> Applied to cgroup/for-3.13-fixes.

Scrap that.  I don't think we can fail css_online for the root css in
3.13-fixes and this would cause conflict with 3.14, so let's not
commit it to 3.13-fixes.  Vladimir, can you please respin the patch on
top of cgroup/for-3.14 but make cgroup_unload_subsys() check whether
css is actually there before calling offline so that it matches the
usual offline path better?

Thanks.

-- 
tejun
