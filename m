Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab3FMRwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:52:46 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:38890 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab3FMRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:52:45 -0400
Date: Thu, 13 Jun 2013 10:52:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 7/7] cpuset: fix to migrate mm correctly in a corner
 case
Message-ID: <20130613175239.GB10799@mtj.dyndns.org>
References: <51B970B0.2040907@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B970B0.2040907@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 03:11:44PM +0800, Li Zefan wrote:
> Before moving tasks out of empty cpusets, update_tasks_nodemask()
> is called, which calls do_migrate_pages(xx, from, to). Then those
> tasks are moved to an ancestor, and do_migrate_pages() is called
> again.
> 
> The first time: from = node_to_be_offlined, to = empty.
> The second time: from = empty, to = ancestor's nodemask.
> 
> so looks like no pages will be migrated.
> 
> Fix this by:
> 
> - Don't call update_tasks_nodemask() on empty cpusets.
> - Pass cs->old_mems_allowed to do_migrate_pages().
> 
> v4: added comment in cpuset_hotplug_update_tasks() and rephased comment
>     in cpuset_attach().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Replaced v3 with this one in cgroup/for-3.11-cpuset.  Thanks!

-- 
tejun
