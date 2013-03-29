Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3C2KgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:36:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51301
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298Ab3C2KgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:36:03 -0400
Message-ID: <1364553360.5053.84.camel@laptop>
Subject: Re: [PATCH v2 0/5] cpuacct, cgroup: Kill cgroup_subsys.active
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Date: Fri, 29 Mar 2013 11:36:00 +0100
In-Reply-To: <51553813.10004@huawei.com>
References: <51553813.10004@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 14:43 +0800, Li Zefan wrote:
> cpuacct is the only user of cgroup_subsys.active flag.
> 
> The flag is needed because cpuacct_charge() and
> cpuacct_account_field() can
> be called when cpuacct hasn't been initialized during system bootup.
> 
> This patch initializes cpuacct earlier, and the result is we don't
> have
> to check the flag in scheduler hot path.
> 
> Note, this patchset is based on "[PATCH v2 0/7] sched: Split cpuacct"
> 
>         http://lkml.org/lkml/2013/3/28/1
> 
> 0001-cpuacct-allocate-per_cpu-cpuusage-for-root-cpuacct-s.patch
> 0002-cpuacct-Initialize-root-cpuacct-earlier.patch
> 0003-cpuacct-Initialize-cpuacct-subsystem-earlier.patch
> 0004-cpuacct-No-need-to-check-subsys-active-state.patch
> 0005-cgroup-Remove-subsys.active-flag.patch


Seems sane enough

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

