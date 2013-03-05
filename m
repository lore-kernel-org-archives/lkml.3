Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3CEReI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:34:08 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:63618 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3CEReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:34:06 -0500
Date: Tue, 5 Mar 2013 09:34:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: avoid accessing modular cgroup subsys
 structure without locking
Message-ID: <20130305173401.GB12795@htj.dyndns.org>
References: <51355EFF.3080804@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51355EFF.3080804@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 10:57:03AM +0800, Li Zefan wrote:
> subsys[i] is set to NULL in cgroup_unload_subsys() at modular unload,
> and that's protected by cgroup_mutex, and then the memory *subsys[i]
> resides will be freed.
> 
> So this is unsafe without any locking:
> 
>   if (!ss || ss->module)
>   ...
> 
> v2:
> - add a comment for enum cgroup_subsys_id
> - simplify the comment in cgroup_exit()
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
