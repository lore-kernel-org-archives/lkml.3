Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaENEVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 00:21:48 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:32645 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaENEVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 00:21:46 -0400
Message-ID: <5372EF45.8060701@huawei.com>
Date: Wed, 14 May 2014 12:21:25 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hannes@cmpxchg.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: iterate cgroup_subsys_states
 directly
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 2014/5/10 5:31, Tejun Heo wrote:
> Hello,
> 
> Currently, while csses (cgroup_subsys_states) have ->parent linkage
> too, only cgroups form full tree through their ->children and
> ->sibling fields and css iterations naturally is implemented by
> iterating cgroups and then dereferencing the css for the specified
> subsystem.
> 
> There are now use cases where controllers need to iterate through
> csses regardless of their online state as long as they have positive

What use cases are we talking about here?

> reference.  This can't easily be achieved by iterating cgroups because
> its css pointer array needs to be cleared on offline and there may be
> multiple dying csses for a cgroup for the same subsystem and there's
> only one pointer per cgroup-subsystem pair.
> 

