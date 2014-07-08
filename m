Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaGHCke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:40:34 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:29452 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaGHCkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:40:33 -0400
Message-ID: <53BB5A13.1070305@huawei.com>
Date: Tue, 8 Jul 2014 10:40:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
CC: Peter Zijlstra <peterz@infradead.org>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <xiaofeng.yan2012@gmail.com>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] sched/rt: overrun could happen in start_hrtick_dl
References: <1404475341-22536-1-git-send-email-xiaofeng.yan@huawei.com> <20140707084150.GC19379@twins.programming.kicks-ass.net> <53BB4510.5090704@huawei.com>
In-Reply-To: <53BB4510.5090704@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/8 9:10, xiaofeng.yan wrote:
> On 2014/7/7 16:41, Peter Zijlstra wrote:
>> On Fri, Jul 04, 2014 at 12:02:21PM +0000, xiaofeng.yan wrote:
>>> It could be wrong for the precision of runtime and deadline
>>> when the precision is within microsecond level. For example:
>>> Task runtime deadline period
>>>   P1   200us   500us   500us
>>>
>>> This case need enbale HRTICK feature by the next command
>>> PC#echo "HRTICK" > /sys/kernel/debug/sched_features
>>> PC#./schedtool -E -t 200000:500000 -e ./test&
>>> PC#trace-cmd record -e sched_switch
>> Are you actually using HRTICK ?
> yes, If HRTICK is close , then all of runtime and deadline will be wrong.

I think what peter meant is, do you use HRTICK in products or
just use it for testing/experiment?

