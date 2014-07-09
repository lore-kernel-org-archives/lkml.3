Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaGIHZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:25:14 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:15453 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaGIHZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:25:10 -0400
Message-ID: <53BCEE4C.6080006@huawei.com>
Date: Wed, 9 Jul 2014 15:25:00 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.17] cgroup: remove sane_behavior support
 on non-default hierarchies
References: <1404344747-7957-1-git-send-email-tj@kernel.org>
In-Reply-To: <1404344747-7957-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.53BCEE53.0020,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 3657e58907ef1a60ae0e9cfca9ff8096
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/3 7:45, Tejun Heo wrote:
> Hello,
> 
> sane_behavior has been used as a development vehicle for the default
> unified hierarchy.  Now that the default hierarchy is in place, the
> flag became redundant and confusing as its usage is allowed on all
> hierarchies.  There are gonna be either the default hierarchy or
> legacy ones.  Let's make that clear by removing sane_behavior support
> on non-default hierarchies.
> 
> This patchset contains the following four patches.
> 
>  0001-cgroup-remove-CGRP_ROOT_OPTION_MASK.patch
>  0002-cgroup-make-interface-file-cgroup.sane_behavior-lega.patch
>  0003-cgroup-remove-sane_behavior-support-on-non-default-h.patch
>  0004-cgroup-clean-up-sane_behavior-handling.patch
> 
> 0001 is a trivial cleanup.
> 
> 0002 removes "cgroup.sane_behavior" from the default hierarchy.
> 
> 0003 removes sane_behavior support on non-default hierarchies.
> 
> 0004 cleans up sane_behavior handling.
> 
> This patchset is on top of a497c3ba1d97 ("Linux 3.16-rc2") and
> available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-dfl-instead-of-sane
> 
> diffstat follows.  Thanks.
> 
>  block/blk-throttle.c   |    6 +-
>  include/linux/cgroup.h |  128 ++++++++++++++++++++-----------------------------
>  kernel/cgroup.c        |   96 +++++++++++++++---------------------
>  kernel/cpuset.c        |   33 +++++-------
>  mm/memcontrol.c        |    7 +-
>  5 files changed, 117 insertions(+), 153 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>

I'm rebasing my cpuset patchset against this.

