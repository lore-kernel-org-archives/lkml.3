Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3CLFR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:17:29 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:63689 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab3CLFRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:17:25 -0400
Message-ID: <513EBA25.8060106@huawei.com>
Date: Tue, 12 Mar 2013 13:16:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build warning after merge of the final tree (tip
 tree related)
References: <20130312154215.f9c3e957c2a2e510f27b826a@canb.auug.org.au>
In-Reply-To: <20130312154215.f9c3e957c2a2e510f27b826a@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/12 12:42, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc defconfig)
> produced this warning:
> 
> In file included from kernel/sched/core.c:85:0:
> kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared inside parameter list [enabled by default]
> kernel/sched/sched.h:1043:39: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> In file included from kernel/sched/cputime.c:7:0:
> kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared inside parameter list [enabled by default]
> kernel/sched/sched.h:1043:39: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> In file included from kernel/sched/idle_task.c:1:0:
> kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared inside parameter list [enabled by default]
> kernel/sched/sched.h:1043:39: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> In file included from kernel/sched/fair.c:35:0:
> kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared inside parameter list [enabled by default]
> kernel/sched/sched.h:1043:39: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> In file included from kernel/sched/stop_task.c:1:0:
> kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared inside parameter list [enabled by default]
> kernel/sched/sched.h:1043:39: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> In file included from kernel/sched/rt.c:6:0:
> kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared inside parameter list [enabled by default]
> kernel/sched/sched.h:1043:39: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> 
> Probably caused by commit c82ba9fa7588 ("sched: Move struct sched_class
> to kernel/sched/sched.h") from the tip tree which removed a forward
> declaration of "struct sched_domain" from include/linux/sched.h - the
> read declaration is protected by CONFIG_SMP (which is not set for this
> build).
> 

Should be fixed by this, and it has been queued in tip:sched/core

Commit-ID:  b719203b846284e77f5c50fca04b458b6484aeae
Gitweb:     http://git.kernel.org/tip/b719203b846284e77f5c50fca04b458b6484aeae
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Thu, 7 Mar 2013 10:00:26 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Mar 2013 09:07:24 +0100

sched: Fix update_group_power() prototype placement to fix build warning when !CONFIG_SMP

