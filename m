Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3AYQmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:42:49 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:59864 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3AYQmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:42:46 -0500
Date: Fri, 25 Jan 2013 08:42:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix cgroup_path() vs rename() race
Message-ID: <20130125164242.GA3081@htj.dyndns.org>
References: <51022FC7.5020607@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51022FC7.5020607@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 03:09:59PM +0800, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> Use dentry_path_raw(), and this vfs API will take care of lockings.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Urgh... why do we even support rename?  :(

Applying to cgroup/for-3.8-fixes w/ stable cc'd.

Thanks.

-- 
tejun
