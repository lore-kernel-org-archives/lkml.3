Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaITRMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:12:37 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63749 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaITRMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:12:35 -0400
Date: Sat, 20 Sep 2014 13:12:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: remove redundant variable in cgroup_mount()
Message-ID: <20140920171231.GB3681@htj.dyndns.org>
References: <541D2366.2020107@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541D2366.2020107@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Sat, Sep 20, 2014 at 02:49:10PM +0800, Zefan Li wrote:
> Both pinned_sb and new_sb indicate if a new superblock is needed,
> so we can just remove new_sb.
> 
> Note now we must check if kernfs_tryget_sb() returns NULL, because
> when it returns NULL, kernfs_mount() may still re-use an existing
> superblock, which is just allocated by another concurent mount.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Ah, this is so much better.  Thanks for doing this.  Applied to
cgroup/for-3.18.

> ---
> 
> Hi Tejun,
> 
> I think you wanted to see the @new_sb argument removed from kernfs_mount(),
> but it's also used in debugfs and we can't use kernfs_tryget_sb() to
> replace the new_sb check.

Bummer, someday. :)

Thanks.

-- 
tejun
