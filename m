Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaBLHCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:02:22 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:28873 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBLHCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:02:20 -0500
Message-ID: <52FB1C72.60605@huawei.com>
Date: Wed, 12 Feb 2014 15:02:10 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: protect modifications to cgroup->idr with
 cgroup_mutex
References: <52FB14A5.9030307@huawei.com> <20140212063713.GA7984@mtj.dyndns.org>
In-Reply-To: <20140212063713.GA7984@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/12 14:37, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Feb 12, 2014 at 02:28:53PM +0800, Li Zefan wrote:
>> v2:
>> - Don't call deactivate_super() inside cgroup_mutex, as cgroup_kill_sb()
>> will be called if sb refcnt reaches 0. I don't think this can happen,
>> as cgroup_create() is called through vfs, so vfs should guarantee the
>> superblock won't disappear. Still better not depend on it even my guess
>> is probably correct.
> 
> If the deadlock can't actually happen, I don't really care either way
> as the code goes away after kernfs conversion anyway.  I've already
> applied v1, so if you think this change is important, can you send an
> incremental patch?
> 

I'm fine to stick with V1.

I'm pretty confident it's safe, as we can increment sb refcnt without
any checking or locking (even cgroup_mutex as the comment says) in
cgroup_create().

