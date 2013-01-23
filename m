Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3AWAgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:36:14 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:35966 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3AWAgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:36:12 -0500
Date: Tue, 22 Jan 2013 16:29:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix bogus kernel warnings when cgroup_create()
 failed
Message-ID: <20130123002950.GC5359@htj.dyndns.org>
References: <50FD15F9.1090701@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FD15F9.1090701@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 06:18:33PM +0800, Li Zefan wrote:
> If cgroup_create() failed and cgroup_destroy_locked() is called to
> do cleanup, we'll see a bunch of warnings:
> 
> cgroup_addrm_files: failed to remove 2MB.limit_in_bytes, err=-2
> cgroup_addrm_files: failed to remove 2MB.usage_in_bytes, err=-2
> cgroup_addrm_files: failed to remove 2MB.max_usage_in_bytes, err=-2
> cgroup_addrm_files: failed to remove 2MB.failcnt, err=-2
> cgroup_addrm_files: failed to remove prioidx, err=-2
> cgroup_addrm_files: failed to remove ifpriomap, err=-2
> ...
> 
> We failed to remove those files, because cgroup_create() has failed
> before creating those cgroup files.
> 
> To fix this, we simply don't warn if cgroup_rm_file() can't find the
> cft entry.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.9.  Thanks!

-- 
tejun
