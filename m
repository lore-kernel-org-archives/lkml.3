Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3LMUsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:48:05 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:61581 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3LMUsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:48:03 -0500
Date: Fri, 13 Dec 2013 15:47:57 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH cgroup/for-3.14] cgroup: fix fail path in
 cgroup_load_subsys()
Message-ID: <20131213204757.GF27070@htj.dyndns.org>
References: <1386875828-5075-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386875828-5075-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:17:08PM +0400, Vladimir Davydov wrote:
> Calling cgroup_unload_subsys() from cgroup_load_subsys() after
> online_css() failure will result in a NULL ptr dereference on attempt to
> offline_css(), because online_css() only assigns css to cgroup on
> success. Let's fix that by skipping calls to offline_css() and
> css_free() in cgroup_unload_subsys() if there is no css, and freeing css
> in cgroup_load_subsys() on online_css() failure.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.14.

Thanks!

-- 
tejun
