Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbaGXA2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:28:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:56594 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933689AbaGXA2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:28:06 -0400
Message-ID: <53D052FC.3070409@huawei.com>
Date: Thu, 24 Jul 2014 08:27:40 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mike Qiu <qiudayu@linux.vnet.ibm.com>, <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/cpuset.c:1139
References: <53CF22F5.6000206@linux.vnet.ibm.com> <20140723151220.GD7103@htj.dyndns.org>
In-Reply-To: <20140723151220.GD7103@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/23 23:12, Tejun Heo wrote:
> On Wed, Jul 23, 2014 at 10:50:29AM +0800, Mike Qiu wrote:
>> commit 734d45130cb ("cpuset: update cs->effective_{cpus, mems} when config
>> changes") introduce the below warning in my server.
>>
>> [   35.652137] ------------[ cut here ]------------
>> [   35.652141] WARNING: at kernel/cpuset.c:1139
> 
> Hah, can you reproduce it?  If so, can you detail how?
> 

It's a typo.

WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
	nodes_equal(cp->mems_allowed, cp->effective_mems));

should be

WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
	!nodes_equal(cp->mems_allowed, cp->effective_mems));

