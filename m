Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaJ0I6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:58:14 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:45017 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaJ0I6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:58:13 -0400
Message-ID: <544E091D.9040102@huawei.com>
Date: Mon, 27 Oct 2014 16:58:05 +0800
From: Yao Dongdong <yaodongdong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched:skip loop non-idle cpus after find an idle cpu
 while find_idlest_cpu
References: <544DB84D.1030504@huawei.com> <20141027080422.GB10867@linux.vnet.ibm.com>
In-Reply-To: <20141027080422.GB10867@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.110.51.36]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.544E0923.009A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: f3c7b49ea9746657e9fdd9ba91ab84c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/27 16:04, Srikar Dronamraju wrote:
> * Yao Dongdong <yaodongdong@huawei.com> [2014-10-27 11:13:17]:
>
>> Idle cpu is idler than non-idle cpu, so we needn't loop non-idle cpus after find an idle cpu.
>>
> While this check looks good,
> I dont see how we are avoiding a loop?
>
> Are you suggesting that we break of the for loop once we set
> shallowest_idle_cpu?
>
Thanks for your review.

I agree that the submit message is a bit misleading, what this patch do is just avoiding search for least_loaded_cpu
in non-idle cpus.

    sched:add check of shallowest_idle_cpu before search for least_loaded_cpu

    Idle cpu is idler than non-idle cpu, so we needn't search for least_loaded_cpu
    after we have found an idle cpu.

what about this?

Thanks,
Yao Dongdong

