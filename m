Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaBLJ1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:27:32 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:57038 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaBLJ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:27:01 -0500
Message-ID: <52FB3E50.8020809@huawei.com>
Date: Wed, 12 Feb 2014 17:26:40 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: protect modifications to cgroup_idr with cgroup_mutex
References: <52F9D9DA.7040108@huawei.com> <20140211102032.GA11946@dhcp22.suse.cz> <20140212091238.GC28085@dhcp22.suse.cz>
In-Reply-To: <20140212091238.GC28085@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/12 17:12, Michal Hocko wrote:
> Li has pointed out that my previous backport was not correct because
> err_unlock label releases a reference to supperblock which was not taken
> before idr_alloc. I've also removed cgroup_mutex from free_css_id as per
> Li.
> Fixed in this version.
> 

Looks good to me!

Are you going to send it to stable mailing list after the fix hits mainline
or use it internally?

It has small conflicts with this patch that will also be backported to 3.12:

https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/commit/kernel/cgroup.c?h=for-3.14-fixes&id=b58c89986a77a23658682a100eb15d8edb571ebb

