Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaHFNmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:42:06 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18960 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaHFNmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:42:01 -0400
Message-ID: <53E23058.3030206@huawei.com>
Date: Wed, 6 Aug 2014 21:40:40 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Will Deacon <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Li Zefan <lizefan@huawei.com>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <peifeiyue@huawei.com>
Subject: Re: [RFC PATCH] kprobes: arm: enable OPTPROBES for arm 32
References: <1407223697-74911-1-git-send-email-wangnan0@huawei.com>	 <53E1B2A0.1040807@hitachi.com> <1407332208.3006.13.camel@linaro1.home>
In-Reply-To: <1407332208.3006.13.camel@linaro1.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/6 21:36, Jon Medhurst (Tixy) wrote:
> On Wed, 2014-08-06 at 13:44 +0900, Masami Hiramatsu wrote:
>> (2014/08/05 16:28), Wang Nan wrote
> [...]
>>> +asm (
>>> +			".global optprobe_template_entry\n"
>>> +			"optprobe_template_entry:\n"
>>> +#ifndef CONFIG_THUMB
>>> +			"	sub	sp, sp, #80\n"
>>> +			"	stmia	sp, {r0 - r14} \n"
>>> +			"	add	r3, sp, #80\n"
>>> +			"	str	r3, [sp, #52]\n"
>>> +			"	mrs	r4, cpsr\n"
>>> +			"	str	r4, [sp, #64]\n"
>>> +			"	mov	r1, sp\n"
>>> +			"	ldr	r0, 1f\n"
>>> +			"	ldr	r2, 2f\n"
>>> +			"	blx	r2\n"
>>> +			"	ldr	r1, [sp, #64]\n"
>>> +			"	msr	cpsr_fs, r1\n"
>>> +			"	ldmia	sp, {r0 - r15}\n"
>>> +			".global optprobe_template_val\n"
>>> +			"optprobe_template_val:\n"
>>> +			"1:	nop\n"
>>> +			".global optprobe_template_call\n"
>>> +			"optprobe_template_call:\n"
>>> +			"2:	nop\n"
>>> +#else /* CONFIG_THUMB */
>>> +# error optprobe for thumb is not supported.
>>
>> Can we set CONFIG_THUMB=y without CONFIG_THUMB2_KERNEL ?
> 
> Yes, CONFIG_THUMB is for supporting userside Thumb code,
> CONFIG_THUMB2_KERNEL is for building the kernel for Thumb and the
> options are orthogonal. So I don't think kprobes code should be testing
> CONFIG_THUMB as it doesn't deal with userside.
> 

You are correct. This is my mistake.


