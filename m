Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbaLEDiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:38:51 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:29445 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaLEDiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:38:50 -0500
Message-ID: <5481289E.4060504@huawei.com>
Date: Fri, 5 Dec 2014 11:38:06 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v12 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>	 <1417671360-53399-1-git-send-email-wangnan0@huawei.com> <1417710073.2239.10.camel@linaro.org>
In-Reply-To: <1417710073.2239.10.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/5 0:21, Jon Medhurst (Tixy) wrote:
> On Thu, 2014-12-04 at 13:36 +0800, Wang Nan wrote:
> 

[trim some text]

> 
> I have retested this patch and on one of the arm test cases I get an
> undefined instruction exception in kprobe_arm_test_cases. When this
> happens PC points to the second nop below. 
> 
> 
> 80028a38:	e320f000 	nop	{0}
> 80028a3c:	e11000b2 	ldrh	r0, [r0, -r2]
> 80028a40:	e320f000 	nop	{0}
> 
> As all three instructions will have probes on them during testing, and
> un-optimised probes are implemented by using an undefined instruction to
> act as a breakpoint, my first thought was that we have a race condition
> somewhere with adding, removing or optimizing probes. Though a reboot a
> retest failed in the same way on the same instruction, so I'm not 100%
> convinced about strictly timing related bugs.
>  

Does the problem appear in your platform in each time? Currently I have only
QEMU machine for testing and haven't seen problem like this before. Could
you please provide a detail steps for me to reproduce it? Or do you just
enable kprobe test code when booting and this exception simply appear twice?

> Meanwhile, I have some review comments of the code below...
> 

[trim some code]

>> +	/*
>> +	 * Add more 4 byte for potential AEABI requirement. If probing is triggered
>> +	 * when SP % 8 == 4, we sub SP by another 4 bytes.
>> +	 */
>> +	stack_protect += orig->ainsn.stack_space + 4;
> 
> The above comment and code don't match up any more with the code in
> optprobe_template_entry, it should be '+ 7' here. Alternatively, change
> the code in optprobe_template_entry back to use 4 as I suggested.
> 
> 

Looks like we don't really need this 4 bytes. ASM code should operate SP correctly in
each case.



