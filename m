Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaF3Blc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 21:41:32 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:31787 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaF3Bla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 21:41:30 -0400
Message-ID: <53B0C042.9030206@huawei.com>
Date: Mon, 30 Jun 2014 09:41:22 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] cgroup: fix mount failure in a corner case
References: <53AD18D0.3090100@huawei.com> <53AD2852.2060304@huawei.com> <53AD35A8.7030908@huawei.com> <20140628115743.GB10829@htj.dyndns.org>
In-Reply-To: <20140628115743.GB10829@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53B0C047.0094,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 136de46ec9474b696f8dab9e843f72e3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/28 19:58, Tejun Heo wrote:
> Hello, Li.
> 
> On Fri, Jun 27, 2014 at 05:13:12PM +0800, Li Zefan wrote:
>> +	for_each_subsys(ss, i) {
>> +		if (!(opts.subsys_mask & (1 << i)) ||
>> +		    ss->root == &cgrp_dfl_root)
>> +			continue;
>> +
>> +		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
>> +			mutex_unlock(&cgroup_mutex);
>> +			msleep(10);
>> +			ret = restart_syscall();
>> +			goto out_free;
>> +		}
> 
> Why not just put it immediately?  We know that it's not gonna be
> destroyed while holding cgroup_mutex.  It may look a bit weird but
> this is a pretty special case anyway and deferring put doesn't buy
> anything.
> 

Yeah, this is better. :)

