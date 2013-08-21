Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3HUOWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:22:01 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:40386 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3HUOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:21:59 -0400
Date: Wed, 21 Aug 2013 10:21:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 00/11] cpuset: separate configured masks and effective
 masks
Message-ID: <20130821142155.GL19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148F52.0@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Aug 21, 2013 at 05:58:42PM +0800, Li Zefan wrote:
> This patcheset introduces behavior changes, but only if you mount cgroupfs
> with sane_behavior option:
> 
> - We introduce new interfaces cpuset.effective_cpus and cpuset.effective_mems,
>   while cpuset.cpus and cpuset.mems will be configured masks.
> 
> - The configured masks can be changed by writing cpuset.cpus/mems only. They
>   won't be changed when hotplug happens.
> 
> - Users can config cpus and mems without restrictions from the parent cpuset.
>   effective masks will enforce the hierarchical behavior.
> 
> - Users can also config cpus and mems to have already offlined CPU/nodes.
> 
> - When a CPU/node is onlined, it will be brought back to the effective masks
>   if it's in the configured masks.
> 
> - We build sched domains based on effective cpumask but not configured cpumask.

Overall, it looks great.  Thank you so much for doing this.  Most of
my reviews are concerned with patch descriptions and documentation.  I
wish they showed clearer what are changed how and why that doesn't
affect !sane behaviors.

Thanks!

-- 
tejun
