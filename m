Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaLHNsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:48:23 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:61194 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaLHNsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:48:21 -0500
Message-ID: <5485AC14.1000207@huawei.com>
Date: Mon, 8 Dec 2014 21:48:04 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v14 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1418020040-68977-1-git-send-email-wangnan0@huawei.com>			 <1418020131-69375-1-git-send-email-wangnan0@huawei.com>		 <1418036666.3647.33.camel@linaro.org> <5485886E.2060303@huawei.com>	 <1418039451.3647.48.camel@linaro.org> <54859454.30603@huawei.com>	 <54859A2C.8030009@huawei.com> <1418044934.3647.61.camel@linaro.org>
In-Reply-To: <1418044934.3647.61.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A0B0205.5485AC23.02C2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 9257eea5d514716c828b0c252b8d71d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/8 21:22, Jon Medhurst (Tixy) wrote:
> On Mon, 2014-12-08 at 20:31 +0800, Wang Nan wrote:
>> On 2014/12/8 20:06, Wang Nan wrote:
>>> On 2014/12/8 19:50, Jon Medhurst (Tixy) wrote:
>>>> On Mon, 2014-12-08 at 19:15 +0800, Wang Nan wrote:
>>>>> On 2014/12/8 19:04, Jon Medhurst (Tixy) wrote:
>>>>>> On Mon, 2014-12-08 at 14:28 +0800, Wang Nan wrote:
>> [...]
>>>>
>>>> so another CPU could find and delete next before this one has finished
>>>> doing so. Would the list end up in a consistent state where no loops
>>>> develop and no probes are missed? I don't know the answer and a full
>>>> analysis would be complicated, but my gut feeling is that if a cpu can
>>>> observe the links in the list in an inconsistent state then only bad
>>>> things can result.
>>>>
>>>
>>> I see the problem.
>>>
>>> I'm thinking about making core.c and opt-arm.c to share stop_machine() code.
>>> stop_machine() is required when removing breakpoint, so I'd like to define
>>> a "remove_breakpoint" function in core.c and make opt-arm.c to call it.
>>> Do you think it is a good idea?
>>>
>>>
>>
>> What I mean is something like this:
> 
> Yes, that should work, though as remove_breakpoint is a globally visible
> symbol, I suggest a less generic name for it, perhaps
> remove_kprobe_breakpoint ?
> 

I don't think it is globally visible. Only files in arm/probes/kprobes
can include "core.h". However, I do agree that remove_breakpoint() is not
a good name. In my v15 patch, I'd like to rename it to kprobe_remove_breakpoint(),
due to may of names defined in core.h are called kprobes_xxx.

Thank you!


