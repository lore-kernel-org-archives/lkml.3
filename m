Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3AYQwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:52:00 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40861 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3AYQv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:51:59 -0500
Date: Fri, 25 Jan 2013 08:51:54 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cpuset: fix cpuset_print_task_mems_allowed() vs
 rename() race
Message-ID: <20130125165154.GB3081@htj.dyndns.org>
References: <51023D61.9000901@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51023D61.9000901@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 04:08:01PM +0800, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> It's safe in the protection of dentry->d_lock.
> 
> v2: check NULL dentry before acquiring dentry lock.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.8-fixes w/ stable cc'd.

Thanks.

-- 
tejun
