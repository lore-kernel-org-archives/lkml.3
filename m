Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaBODiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 22:38:00 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:11044 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaBODh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 22:37:58 -0500
Message-ID: <52FEE10C.7010101@huawei.com>
Date: Sat, 15 Feb 2014 11:37:48 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: update cgroup_enable_task_cg_lists()
 to grab siglock
References: <20140213182931.GB17608@htj.dyndns.org>
In-Reply-To: <20140213182931.GB17608@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/14 2:29, Tejun Heo wrote:
> Currently, there's nothing preventing cgroup_enable_task_cg_lists()
> from missing set PF_EXITING and race against cgroup_exit().  Depending
> on the timing, cgroup_exit() may finish with the task still linked on
> css_set leading to list corruption.  Fix it by grabbing siglock in
> cgroup_enable_task_cg_lists() so that PF_EXITING is guaranteed to be
> visible.
> 
> This whole on-demand cg_list optimization is extremely fragile and has
> ample possibility to lead to bugs which can cause things like
> once-a-year oops during boot.  I'm wondering whether the better
> approach would be just adding "cgroup_disable=all" handling which
> disables the whole cgroup rather than tempting fate with this
> on-demand craziness.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: stable@vger.kernel.org

Acked-by: Li Zefan <lizefan@huawei.com>

