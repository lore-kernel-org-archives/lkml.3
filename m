Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaARBJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 20:09:16 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:46771 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaARBJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 20:09:13 -0500
Message-ID: <52D9D421.6040608@huawei.com>
Date: Sat, 18 Jan 2014 09:08:49 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
        "Thomas Graf" <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        "Daniel Borkmann" <dborkman@redhat.com>
Subject: Re: [PATCH 1/6] cgroup: make CONFIG_NET_CLS_CGROUP and CONFIG_NETPRIO_CGROUP
 bool instead of tristate
References: <1389982317-22225-1-git-send-email-tj@kernel.org> <1389982317-22225-2-git-send-email-tj@kernel.org>
In-Reply-To: <1389982317-22225-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Daniel Borkmann <dborkman@redhat.com>

On 2014/1/18 2:11, Tejun Heo wrote:
> net_cls and net_prio are the only cgroups which are allowed to be
> built as modules.  The savings from allowing the two controllers to be
> built as modules are tiny especially given that cgroup module support
> itself adds quite a bit of complexity.
> 
> The following are the sizes of vmlinux with both built as module and
> both built as part of the kernel image with cgroup module support
> removed.
> 
> 	text		data		bss		dec
> 	20292207	2411496		10784768	33488471
> 	20293421	2412568		10784768	33490757
> 
> The total difference is 2286 bytes.  Given that none of other
> controllers has much chance of being made a module and that we're
> unlikely to add new modular controllers, the added complexity is
> simply not justifiable.
> 
> As a first step to drop cgroup module support, this patch changes the
> two config options to bool from tristate and drops module related code
> from the two controllers.
> 

I sugguested Daniel to do this for net_cls, and the change has been in
net-next.

https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=fe1217c4f3f7d7cbf8efdd8dd5fdc7204a1d65a8

I was planning to remove module support after that change goes into
upstream. :)

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  net/Kconfig               |  2 +-
>  net/core/netprio_cgroup.c | 32 ++------------------------------
>  net/sched/Kconfig         |  2 +-
>  net/sched/cls_cgroup.c    | 23 ++---------------------
>  4 files changed, 6 insertions(+), 53 deletions(-)
> 

The modular version of task_netprioidx() in include/net/netprio_cgroup.h
can be removed.

