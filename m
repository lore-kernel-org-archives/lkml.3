Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaBLGhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 01:37:19 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:43231 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaBLGhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 01:37:17 -0500
Date: Wed, 12 Feb 2014 01:37:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: protect modifications to cgroup->idr with
 cgroup_mutex
Message-ID: <20140212063713.GA7984@mtj.dyndns.org>
References: <52FB14A5.9030307@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FB14A5.9030307@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Feb 12, 2014 at 02:28:53PM +0800, Li Zefan wrote:
> v2:
> - Don't call deactivate_super() inside cgroup_mutex, as cgroup_kill_sb()
> will be called if sb refcnt reaches 0. I don't think this can happen,
> as cgroup_create() is called through vfs, so vfs should guarantee the
> superblock won't disappear. Still better not depend on it even my guess
> is probably correct.

If the deadlock can't actually happen, I don't really care either way
as the code goes away after kernfs conversion anyway.  I've already
applied v1, so if you think this change is important, can you send an
incremental patch?

Thanks!

-- 
tejun
