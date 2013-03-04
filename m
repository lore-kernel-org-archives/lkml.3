Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab3CDSFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:05:15 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:46474 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435Ab3CDSFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:05:13 -0500
Date: Mon, 4 Mar 2013 10:05:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroup: no need to check css refs for release
 notification
Message-ID: <20130304180508.GF30413@htj.dyndns.org>
References: <5130535F.7060201@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5130535F.7060201@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 03:06:07PM +0800, Li Zefan wrote:
> We no longer fail rmdir() when there're still css refs, so we don't
> need to check css refs in check_for_release().
> 
> This also voids a bug. cgroup_has_css_refs() accesses subsys[i]
> without cgroup_mutex, so it can race with cgroup_unload_subsys().
> 
> cgroup_has_css_refs()
> ...
>   if (ss == NULL || ss->root != cgrp->root)
> 
> if ss pointers to net_cls_subsys, and cls_cgroup module is unloaded
> right after the former check but before the latter, the memory that
> net_cls_subsys resides has become invalid.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
