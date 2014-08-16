Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaHPBjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 21:39:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:16221 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaHPBjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 21:39:43 -0400
Message-ID: <53EEB60D.1030907@huawei.com>
Date: Sat, 16 Aug 2014 09:38:21 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>, <ananth@in.ibm.com>,
        <anil.s.keshavamurthy@intel.com>, <davem@davemloft.net>,
        Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>, <lizefan@huawei.com>
Subject: Re: [PATCH v4] kprobes: arm: enable OPTPROBES for ARM 32
References: <1407819388-52145-1-git-send-email-wangnan0@huawei.com> <53EE25FB.4070201@hitachi.com>
In-Reply-To: <53EE25FB.4070201@hitachi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020207.53EEB622.0037,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 5b1060f776432d32069cc892e1fd6f61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/15 23:23, Masami Hiramatsu wrote:
> (2014/08/12 13:56), Wang Nan wrote:
>> +/* Caller must ensure addr & 3 == 0 */
>> +static int can_optimize(unsigned long paddr)
>> +{
>> +	return 1;
>> +}
> 
> As we have talked on another thread, we'd better filter-out all stack-pushing
> instructions here, since (as you said) that will corrupt pt_regs on the stack.
> 
> Thank you,
> 

So we need to identify the replaced instruction. I think some improvement on
arm instruction decoder is required, else we have to implement another (although simpler)
decoder for memory accessing instructions.

In this situation we are talking about, we need the decoder identify the addressing
information for str/stm instroction. However, decoder can bring up more information such as
instruction type, source/destnation registers, memory access pattern ...
With such information, we can further optimize our trampoline code.
For example: doesn't protect destnation registers, and for some (most of, I think) instruction,
we can direct execute them like x86_64.

What do you think?


