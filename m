Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbbAHDLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 22:11:05 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48974 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbbAHDLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 22:11:03 -0500
MIME-Version: 1.0
In-Reply-To: <54AD731F.3080408@codeaurora.org>
References: <1420535256-6091-1-git-send-email-js07.lee@gmail.com>
	<878uhf4457.fsf@rustcorp.com.au>
	<54AD731F.3080408@codeaurora.org>
Date: Thu, 8 Jan 2015 12:03:47 +0900
Message-ID: <CAPP0e=PF0Dne8i=uR4OvLA6ujCwJDv7T6q2m-Jy_6TGYihJeEw@mail.gmail.com>
Subject: Re: [PATCH] kernel/module.c: Mark module state before set RO and NX regions
From: Jungseung Lee <js07.lee@gmail.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-08 2:55 GMT+09:00 Laura Abbott <lauraa@codeaurora.org>:
> On 1/6/2015 8:16 PM, Rusty Russell wrote:
>>
>> Jungseung Lee <js07.lee@gmail.com> writes:
>>>
>>> In some architectures like arm/arm64, set_memory_*() check module address
>>> and state as well. Mark module state before set RO and NX regions for
>>> the routine is passed.
>>>
>>> It will fix wrong RO/NX protection for loadable kernel modules on
>>> arm/arm64.
>>
>>
>> This partially reverts commit 4982223e51e8ea9d09bb33c8323b5ec1877b2b51
>> Author: Rusty Russell <rusty@rustcorp.com.au>
>> Date:   Wed May 14 10:54:19 2014 +0930
>>
>>      module: set nx before marking module MODULE_STATE_COMING.
>>
>> Laura Abbott (CC'd) was looking at an alternative fix for this.  Laura?
>>
>> Thanks,
>> Rusty.
>>
>
> Yes, my proposal was to stop using is_module_address and just bounds
> check against the module ranges[1]. I got bogged down with other
> tasks and hadn't submitted a patch for review yet.
>
I got it. I'll prepare bounds check patch for aarch32.
Thanks,

> Thanks,
> Laura
>
> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/311574.html
>
>
> --
> Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
