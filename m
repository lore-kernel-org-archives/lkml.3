Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab3HNCBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 22:01:37 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:38979 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856Ab3HNCBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 22:01:36 -0400
Message-ID: <520AE4FC.5090702@huawei.com>
Date: Wed, 14 Aug 2013 10:01:32 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write functions
References: <5209892D.8070502@huawei.com> <52098941.4070600@huawei.com> <20130813150549.GF26596@mtj.dyndns.org>
In-Reply-To: <20130813150549.GF26596@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/13 23:05, Tejun Heo wrote:
> On Tue, Aug 13, 2013 at 09:17:53AM +0800, Li Zefan wrote:
>> Now cgroup core gets a reference to the css when a cgroup file is
>> opened(), and the reference is dropped at file release. so it's
>> guaranteed the cpuset is online during the write function.
> 
> Hmmm... it doesn't really guarantee that as css's can be offlined with
> residual css refcnts, os the css may well be offlined by the time it
> reaches the rw functions.  What's guaranteed is that their refcnts
> wouldn't be zero.

Oh, right.

But most controllers don't check this in those read/write functions.
It shoudn't do any harm not checking online/offline status.

> Eventually we need to implement proper sever
> semantics (probably by replacing the custom fs implementation with
> sysfs) but right now controllers still need to deal with offline
> css's.
> 
> Thanks.
> 

