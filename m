Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaFXBPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 21:15:12 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:40693 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaFXBPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 21:15:10 -0400
Message-ID: <53A8D115.5060302@huawei.com>
Date: Tue, 24 Jun 2014 09:15:01 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 3/5] cgroup: fix mount failure in a corner case
References: <53994943.60703@huawei.com> <5399496D.6060003@huawei.com> <20140620191025.GA28324@mtj.dyndns.org>
In-Reply-To: <20140620191025.GA28324@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.53A8D11C.0015,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 30cc20d08f4cf7d56c90556c83d1bcfa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/21 3:10, Tejun Heo wrote:
> On Thu, Jun 12, 2014 at 02:32:13PM +0800, Li Zefan wrote:
>> @@ -1677,6 +1679,22 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>>  		goto out_unlock;
>>  	}
>>  
>> +	/*
>> +	 * If some subsystems have been bound to existing cgroup hierarchies,
>> +	 * but those hierachies are being destroyed, let's wait a little bit
>> +	 * and retry.
>> +	 */
>> +	for_each_subsys(ss, i) {
>> +		if (!(opts.subsys_mask & (1 << i)))
>> +			continue;
>> +		if (!percpu_ref_alive(&ss->root->cgrp.self.refcnt)) {
> 
> Can't we just do tryget_live() instead and then put before retrying?
> It's not exactly a hot path and the operations are dirt cheap anyway.
> 

No much difference, though would be a bit more code. I can do that.

