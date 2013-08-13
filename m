Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab3HMBTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:19:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6869 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3HMBTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:19:19 -0400
Message-ID: <5209898A.6040304@huawei.com>
Date: Tue, 13 Aug 2013 09:19:06 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: decouple cgroup_subsys_state
 lifetime from that of cgroup
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/9 4:13, Tejun Heo wrote:
> Hello,
> 
> Currently a css's (cgroup_subsys_state) lifetime is tied to that of
> the cgroup it's attached to.  css's are created when the cgroup is
> created and destroyed together.  The access rules depend on it too -
> e.g. css's can be dereferenced while holding RCU read lock because
> cgroup is protected with RCU.
> 
> With the planned unified hierarchy, we'll be dynamically creating and
> destroying css's through the lifetime of a cgroup, so we can no longer
> hitch css lifetime management onto cgroup's.  This patchset separates
> out css lifetime management from that of cgroup.  After the patchset,
> each css is individually RCU protected.
> 
> This patchset contains the following 14 patches.
> 
>  0001-cgroup-always-use-cgroup_css.patch
>  0002-cgroup-rename-cgroup_subsys_state-dput_work-and-its-.patch
>  0003-cgroup-add-cgroup_subsys_state-parent.patch
>  0004-cgroup-cgroup_css_from_dir-now-should-be-called-with.patch
>  0005-cgroup-make-cgroup_file_open-rcu_read_lock-around-cg.patch
>  0006-cgroup-add-__rcu-modifier-to-cgroup-subsys.patch
>  0007-cgroup-reorganize-css-init-exit-paths.patch
>  0008-cgroup-move-cgroup-subsys-assignment-to-online_css.patch
>  0009-cgroup-bounce-cgroup_subsys_state-ref-kill-confirmat.patch
>  0010-cgroup-replace-cgroup-css_kill_cnt-with-nr_css.patch
>  0011-cgroup-decouple-cgroup_subsys_state-destruction-from.patch
>  0012-cgroup-factor-out-kill_css.patch
>  0013-cgroup-move-subsys-file-removal-to-kill_css.patch
>  0014-cgroup-RCU-protect-each-cgroup_subsys_state-release.patch
> 

Acked-by: Li Zefan <lizefan@huawei.com>

