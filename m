Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaA2Gc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 01:32:59 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:17618 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaA2Gc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 01:32:57 -0500
Message-ID: <52E8A086.2050103@huawei.com>
Date: Wed, 29 Jan 2014 14:32:38 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.15] cgroup: drop module support and
 cgroup_root_mutex
References: <1390952641-15950-1-git-send-email-tj@kernel.org>
In-Reply-To: <1390952641-15950-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/29 7:43, Tejun Heo wrote:
> Hello,
> 
> This is the second take.  Changes from the last take[L] are
> 
> * Updated to reflect changes in fe1217c4f3f7 ("net: net_cls: move
>   cgroupfs classid handling into core").
> 
> * Rebased on top of the current linus#master + some cgroup fix
>   patches.
> 
> There's only one controller which makes use of the module support -
> net_prio, which, non-coincidentally, isn't an actual resource
> controller.  It's highly unlikely that the actual resource controlling
> controllers are gonna be made modular and we aren't gonna add more
> non-resource controllers either, so the value of module support is
> strictly restricted to the particular controller.
> 
> The controller is fairly simple while module support in cgroup core
> adds quite a bit of complexity.  Building the one controller as module
> only saves less than half-page in vmlinux, which really can't justify
> the additional complexity and (minute but existing) runtime overhead.
> 
> This patchset makes net_prio config options bool so that it can't be
> built as modules and drops module support from cgroup core, which in
> turn facilitates further simplification leading to removal of
> cgroup_root_mutex by allowing iterating subsystems outside the
> mutexes.
> 
> This patchset contains the following six patches.
> 
>  0001-cgroup-make-CONFIG_CGROUP_NET_PRIO-bool-and-drop-unn.patch
>  0002-cgroup-drop-module-support.patch
>  0003-cgroup-clean-up-cgroup_subsys-names-and-initializati.patch
>  0004-cgroup-rename-cgroup_subsys-subsys_id-to-id.patch
>  0005-cgroup-update-locking-in-cgroup_show_options.patch
>  0006-cgroup-remove-cgroup_root_mutex.patch
> 
> 0001-0002 drop cgroup module support.
> 
> 0003-0004 are cleanups.
> 
> 0005-0006 remove cgroup_root_mutex.
> 

Acked-by: Li Zefan <lizefan@huawei.com>

