Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaLAI75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:59:57 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:12262 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaLAI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:59:56 -0500
Message-ID: <547C2DFE.7010005@huawei.com>
Date: Mon, 1 Dec 2014 16:59:42 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>, <taras.kondratiuk@linaro.org>,
        <ben.dooks@codethink.co.uk>, <cl@linux.com>, <rabin@rab.in>,
        <davem@davemloft.net>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1416551751-50846-1-git-send-email-wangnan0@huawei.com>	 <1416551751-50846-3-git-send-email-wangnan0@huawei.com> <1417099007.2041.6.camel@linaro.org> <547BC490.9020806@huawei.com>
In-Reply-To: <547BC490.9020806@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.547C2E0B.001D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 5eab2da87ec146b6f25dc31e7f8256c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> +/*
>>> + * NOTE: the first sub and add instruction will be modified according
>>> + * to the stack cost of the instruction.
>>> + */
>>> +asm (
>>> +			".global optprobe_template_entry\n"
>>> +			"optprobe_template_entry:\n"
>>> +			"	sub	sp, sp, #0xff\n"
>>> +			"	stmia	sp, {r0 - r14} \n"
>>
>> AEABI requires that the stack be aligned to a multiple of 8 bytes at
>> function call boundaries, however kprobes can be inserted in the middle
>> of functions where such alignment isn't guaranteed to be maintained.
>> Therefore, this trampoline code needs to make adjust SP if necessary to
>> ensure that alignment. See svc_entry in arch/arm/kernel/entry-armv.S for
>> an example of how this is done; though note, we can't use that exact
>> method because we can't change the flags value without saving them
>> first. (Exception handlers don't have to worry about that because the
>> flags are saved in spsr).
>>
> 
> So I think we have to push a flag into stack for it.
> 

By more thinking I found another method on it. Please see my version 11 patch:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/307562.html


