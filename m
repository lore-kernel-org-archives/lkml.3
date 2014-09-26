Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaIZE0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:26:23 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:32849 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaIZE0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:26:21 -0400
Date: Fri, 26 Sep 2014 00:26:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] Revert "cgroup: remove redundant variable in
 cgroup_mount()"
Message-ID: <20140926042617.GA14426@htj.dyndns.org>
References: <1411704205-28995-1-git-send-email-lizefan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411704205-28995-1-git-send-email-lizefan@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 12:03:25PM +0800, Zefan Li wrote:
> This reverts commit 0c7bf3e8cab7900e17ce7f97104c39927d835469.
> 
> If there are child cgroups in the cgroupfs and then we umount it,
> the superblock will be destroyed but the cgroup_root will be kept
> around. When we mount it again, cgroup_mount() will find this
> cgroup_root and allocate a new sb for it.
> 
> So with this commit we will be trapped in a dead loop in the case
> described above, because kernfs_pin_sb() keeps returning NULL.
> 
> Currently I don't see how we can avoid using both pinned_sb and
> new_sb, so just revert it.
> 
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Reported-by: Andrey Wagin <avagin@gmail.com>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
