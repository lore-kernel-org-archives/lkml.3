Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbbAGRzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:55:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43059 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbbAGRzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:55:47 -0500
Message-ID: <54AD731F.3080408@codeaurora.org>
Date: Wed, 07 Jan 2015 09:55:43 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Jungseung Lee <js07.lee@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/module.c: Mark module state before set RO and
 NX regions
References: <1420535256-6091-1-git-send-email-js07.lee@gmail.com> <878uhf4457.fsf@rustcorp.com.au>
In-Reply-To: <878uhf4457.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2015 8:16 PM, Rusty Russell wrote:
> Jungseung Lee <js07.lee@gmail.com> writes:
>> In some architectures like arm/arm64, set_memory_*() check module address
>> and state as well. Mark module state before set RO and NX regions for
>> the routine is passed.
>>
>> It will fix wrong RO/NX protection for loadable kernel modules on arm/arm64.
>
> This partially reverts commit 4982223e51e8ea9d09bb33c8323b5ec1877b2b51
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Wed May 14 10:54:19 2014 +0930
>
>      module: set nx before marking module MODULE_STATE_COMING.
>
> Laura Abbott (CC'd) was looking at an alternative fix for this.  Laura?
>
> Thanks,
> Rusty.
>

Yes, my proposal was to stop using is_module_address and just bounds
check against the module ranges[1]. I got bogged down with other
tasks and hadn't submitted a patch for review yet.

Thanks,
Laura

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/311574.html


-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
