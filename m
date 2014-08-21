Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaHUONg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:13:36 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:40928 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaHUONe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:13:34 -0400
Date: Thu, 21 Aug 2014 09:13:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Li Zefan <lizefan@huawei.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Heaton <matt@betterlinux.com>
Subject: Re: [PATCH] cgroup: add tracepoints to track cgroup events
Message-ID: <20140821141330.GA1766@mtj.dyndns.org>
References: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 20, 2014 at 09:46:25PM -0600, Andrea Righi wrote:
> This patch adds the following tracepoints:
>  o trace_cgroup_create       when a new cgroup is created
>  o trace_cgroup_destroy      when a cgroup is removed
>  o trace_cgroup_task_migrate when a task/thread is moved from a cgroup to another
> 
> The purpose of these tracepoints is to identify and help cgroup "managers" to
> diagnose problems and detect when they are doing an excessive amount of work.

Using TPs for this looks like a really roundabout way of doing this
when the whole interface is based on filesystem.  Extending
kernfs_notity to support directory events seems like a better way to
do this.

Thanks.

-- 
tejun
