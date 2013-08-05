Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3HED1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 23:27:18 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:55407 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3HED1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 23:27:16 -0400
Message-ID: <51FF1B7A.8070607@huawei.com>
Date: Mon, 5 Aug 2013 11:26:50 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] memcg: rename cgroup_event to mem_cgroup_event
References: <1375632446-2581-1-git-send-email-tj@kernel.org> <1375632446-2581-6-git-send-email-tj@kernel.org>
In-Reply-To: <1375632446-2581-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/5 0:07, Tejun Heo wrote:
> cgroup_event is only available in memcg now.  Let's brand it that way.
> While at it, add a comment encouraging deprecation of the feature and
> remove the respective section from cgroup documentation.
> 
> This patch is cosmetic.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  Documentation/cgroups/cgroups.txt | 19 -------------
>  mm/memcontrol.c                   | 57 +++++++++++++++++++++++++--------------
>  2 files changed, 37 insertions(+), 39 deletions(-)
> 
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index 638bf17..ca5aee9 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -472,25 +472,6 @@ you give a subsystem a name.
>  The name of the subsystem appears as part of the hierarchy description
>  in /proc/mounts and /proc/<pid>/cgroups.
> 

2. Usage Examples and Syntax
  2.1 Basic Usage
  2.2 Attaching processes
  2.3 Mounting hierarchies by name
  2.4 Notification API

remove the index ?
 
> -2.4 Notification API
> ---------------------
> -
> -There is mechanism which allows to get notifications about changing
> -status of a cgroup.
> -
> -To register a new notification handler you need to:
> - - create a file descriptor for event notification using eventfd(2);
> - - open a control file to be monitored (e.g. memory.usage_in_bytes);
> - - write "<event_fd> <control_fd> <args>" to cgroup.event_control.
> -   Interpretation of args is defined by control file implementation;
> -
> -eventfd will be woken up by control file implementation or when the
> -cgroup is removed.
> -
> -To unregister a notification handler just close eventfd.
> -
> -NOTE: Support of notifications should be implemented for the control
> -file. See documentation for the subsystem.
>  

Why not move this section to Documentation/cgroups/memory.txt?

