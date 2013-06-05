Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab3FETp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:45:29 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:44779 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3FETp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:45:27 -0400
Date: Wed, 5 Jun 2013 12:45:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH v2 06/10] cpuset: record old_mems_allowed in struct cpuset
Message-ID: <20130605194522.GG10693@mtj.dyndns.org>
References: <51AF0183.8070602@huawei.com>
 <51AF01E8.8080205@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AF01E8.8080205@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Jun 05, 2013 at 05:16:24PM +0800, Li Zefan wrote:
> @@ -1425,7 +1435,6 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
>  	 * Change mm, possibly for multiple threads in a threadgroup. This is
>  	 * expensive and may sleep.
>  	 */
> -	cpuset_attach_nodemask_to = cs->mems_allowed;
>  	mm = get_task_mm(leader);
>  	if (mm) {
>  		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);

This looks a bit suspicious to me.  Now we're setting mm's nodemask to
guarantee_online_mems() output rather than cs->mems_allowed.  Is this
change intended?  If so, it probably deserves an explanation in the
description?

Thanks.

-- 
tejun
