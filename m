Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab3ENPiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:38:17 -0400
Received: from mail-gg0-f175.google.com ([209.85.161.175]:50264 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab3ENPiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:38:16 -0400
Date: Tue, 14 May 2013 08:38:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Ivan Bulatovic <combuster@archlinux.us>
Subject: Re: [PATCH] cgroup: initialize xattr before calling d_instantiate()
Message-ID: <20130514153810.GD6795@mtj.dyndns.org>
References: <51922394.2020002@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51922394.2020002@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 07:44:20PM +0800, Li Zefan wrote:
> cgroup_create_file() calls d_instantiate(), which may decide to look
> at the xattrs on the file. Smack always does this and SELinux can be
> configured to do so.
> 
> But cgroup_add_file() didn't initialize xattrs before calling
> cgroup_create_file(), which finally leads to dereferencing NULL
> dentry->d_fsdata.
> 
> This bug has been there since cgroup xattr was introduced.
> 
> Cc: <stable@vger.kernel.org> # 3.8.x
> Reported-by: Ivan Bulatovic <combuster@archlinux.us>
> Reported-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10-fixes.

Thanks.

-- 
tejun
