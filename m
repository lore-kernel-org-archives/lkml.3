Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBZNoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:44:44 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:43614 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaBZNom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:44:42 -0500
Date: Wed, 26 Feb 2014 08:44:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: linux-next: build failure after merge of the cgroup tree
Message-ID: <20140226134439.GA17302@htj.dyndns.org>
References: <20140226174655.b5430a1a2413ddb459dababe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226174655.b5430a1a2413ddb459dababe@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:46:55PM +1100, Stephen Rothwell wrote:
> Hi Tejun,
> 
> After merging the cgroup tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/cgroup.c: In function 'cgroup_mount':
> kernel/cgroup.c:1572:2: error: too few arguments to function 'kernfs_mount'
>   dentry = kernfs_mount(fs_type, flags, root->kf_root);
>   ^
> 
> Caused by commit 2bd59d48ebfb ("cgroup: convert to kernfs") interacting
> with commit fed95bab8d29 ("sysfs: fix namespace refcnt leak") from the
> driver-core.current tree.
> 
> I added the following merge fix patch, but it may not be completely
> correct, please check.

Yes, that should be fine for now.  I'll soon pull in Greg's tree into
cgroup and apply Li's refcnt fix to cgroup too.

Thanks.

-- 
tejun
