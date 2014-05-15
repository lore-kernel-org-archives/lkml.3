Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaEOTHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:07:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56004 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaEOTHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:07:17 -0400
Message-ID: <53751062.2050401@wwwdotorg.org>
Date: Thu, 15 May 2014 13:07:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, lizefan@huawei.com
CC: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 9/9] cgroup: use cgroup->self.refcnt for cgroup refcnting
References: <1399670015-23463-1-git-send-email-tj@kernel.org> <1399670015-23463-10-git-send-email-tj@kernel.org>
In-Reply-To: <1399670015-23463-10-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 03:13 PM, Tejun Heo wrote:
> Currently cgroup implements refcnting separately using atomic_t
> cgroup->refcnt.  The destruction paths of cgroup and css are rather
> complex and bear a lot of similiarities including the use of RCU and
> bouncing to a work item.
> 
> This patch makes cgroup use the refcnt of self css for refcnting
> instead of using its own.  This makes cgroup refcnting use css's
> percpu refcnt and share the destruction mechanism.
>...

In next-20150515, this patch causes silent boot failures on NVIDIA Tegra
ARM systems. There isn't even any earlyprintk. Reverting this one patch
solves this.

I was a bit surprised that cgroups would cause such an issue, but
looking at a normal kernel boot, I guess cgroup does get initialized
very early:

Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct

Anyway, I'll try to track down what the problem is, but if someone
familiar with this patch could give it a look, that'd be very useful,
since I'm not at all familiar with this code or feature.
