Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3IKAtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:49:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41884 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3IKAty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:49:54 -0400
Message-ID: <522FBE1E.4020208@huawei.com>
Date: Wed, 11 Sep 2013 08:49:34 +0800
From: Libin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <mingo@redhat.com>,
        <wangyijing@huawei.com>, <guohanjun@huawei.com>
Subject: Re: [PATCH] workqueue: remove redundant timer_stats_timer_set_start_info()
 call
References: <1378794927-4396-1-git-send-email-huawei.libin@huawei.com> <20130910134533.GB7275@htj.dyndns.org>
In-Reply-To: <20130910134533.GB7275@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/10 21:45, Tejun Heo wrote:
> On Tue, Sep 10, 2013 at 02:35:27PM +0800, Libin wrote:
>> From: Li Bin <huawei.libin@huawei.com>
>>
>> There is a redundant call for timer_stats_timer_set_start_info(),
>> because it is the responsibility of the 'timer add' function:
>>
>> add_timer_on()
>> |- timer_stats_timer_set_start_info()
>>
>> add_timer()
>> |- mod_timer()
>> 	|- __mod_timer()
>> 		|- timer_stats_timer_set_start_info()
>>
>> So the calling here is redundant, remove it.
> 
> I think it's intentional to record the caller's address so that timers
> from delayed_work items can be distinguished.
> 

Indeed the case, thank you tejun.
Libin

> Thanks.
> 


