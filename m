Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaEMFAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:00:25 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:52036 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaEMFAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:00:23 -0400
Message-ID: <5371A6DB.2050908@huawei.com>
Date: Tue, 13 May 2014 13:00:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] cgroup: use restart_syscall() for retries after offline
 waits in cgroup_subtree_control_write()
References: <1399663975-315-1-git-send-email-tj@kernel.org> <1399663975-315-6-git-send-email-tj@kernel.org>
In-Reply-To: <1399663975-315-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 2014/5/10 3:32, Tejun Heo wrote:
> After waiting for a child to finish offline,
> cgroup_subtree_control_write() jumps up to retry from after the input
> parsing and active protection breaking.  This retry makes the
> scheduled locking update more difficult.

Could you explain this sentence more specific? I don't understand what
"scheduled locking update" means.

>  Let's simplify it by
> returning with restart_syscall() for retries.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/cgroup.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

