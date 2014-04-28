Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaD1Ddf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 23:33:35 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:20166 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaD1Ddd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 23:33:33 -0400
Message-ID: <535DCBFC.4000404@huawei.com>
Date: Mon, 28 Apr 2014 11:33:16 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hannes@cmpxchg.org>, <mhocko@suse.cz>, <nasa4836@gmail.com>
Subject: Re: [PATCH 6/6] cgroup, memcg: implement css->id and convert css_from_id()
 to use it
References: <1398373333-1521-1-git-send-email-tj@kernel.org> <1398373333-1521-7-git-send-email-tj@kernel.org>
In-Reply-To: <1398373333-1521-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/25 5:02, Tejun Heo wrote:
> Until now, cgroup->id has been used to identify all the associated
> csses and css_from_id() takes cgroup ID and returns the matching css
> by looking up the cgroup and then dereferencing the css associated
> with it; however, now that the lifetimes of cgroup and css are
> separate, this is incorrect and breaks on the unified hierarchy when a
> controller is disabled and enabled back again before the previous
> instance is released.
> 
> This patch adds css->id which is a subsystem-unique ID and converts
> css_from_id() to look up by the new css->id instead.  memcg is the
> only user of css_from_id() and also converted to use css->id instead.
> 

netprio_cgroup also needs to be updated.

> For traditional hierarchies, this shouldn't make any functional
> difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  include/linux/cgroup.h |  9 ++++++++
>  kernel/cgroup.c        | 59 ++++++++++++++++++++++++++++++++------------------
>  mm/memcontrol.c        |  4 ++--
>  3 files changed, 49 insertions(+), 23 deletions(-)
> 


