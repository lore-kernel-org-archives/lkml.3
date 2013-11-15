Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3KOITm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:19:42 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51163 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3KOITe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:19:34 -0500
Date: Fri, 15 Nov 2013 17:19:29 +0900
From: Tejun Heo <tj@kernel.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: 3.10.16 cgroup css_set_lock deadlock
Message-ID: <20131115081929.GA11530@mtj.dyndns.org>
References: <20131114232529.GB16725@sbohrermbp13-local.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114232529.GB16725@sbohrermbp13-local.rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 05:25:29PM -0600, Shawn Bohrer wrote:
> In trying to reproduce the cgroup_mutex deadlock I reported earlier
> in https://lkml.org/lkml/2013/11/11/574 I believe I encountered a
> different issue that I'm also unable to understand. This machine
> started out reporting some soft lockups that look to me like they are
> on a read_lock(css_set_lock):
> 
...
> RIP: 0010:[<ffffffff8109253c>]  [<ffffffff8109253c>] cgroup_attach_task+0xdc/0x7a0
...
>  [<ffffffff81092e87>] attach_task_by_pid+0x167/0x1a0
>  [<ffffffff81092ef3>] cgroup_tasks_write+0x13/0x20

Most likely the bug fixed by ea84753c98a7 ("cgroup: fix to break the
while loop in cgroup_attach_task() correctly").  3.10.19 contains the
backported fix.

Thanks.

-- 
tejun
