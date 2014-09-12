Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaILJFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:05:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:65061 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaILJFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:05:35 -0400
Message-ID: <5412B6EE.1040405@huawei.com>
Date: Fri, 12 Sep 2014 17:03:42 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v2] arm64: add guard macros of unistd.h to prevent double
 inclusion
References: <1410235185-16652-1-git-send-email-yangyingliang@huawei.com> <20140909123938.GL1754@arm.com> <54115583.8080306@huawei.com> <5411698E.3000402@huawei.com> <20140911150212.GP6158@arm.com>
In-Reply-To: <20140911150212.GP6158@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.231]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/11 23:02, Will Deacon wrote:
> On Thu, Sep 11, 2014 at 10:21:18AM +0100, Yang Yingliang wrote:
>> From: Yang Yingliang <yangyingliang@huawei.com>
>>
>> Add guard macros for uapi/asm/unistd.h, asm/unistd.h and
>> asm/unistd32.h.
> 
> Hmm, so I applied this and now my machine panics when we hit userspace. I
> think the issue is that we no longer generate our syscall table in
> arch/arm64/kernel/sys.c, because unistd.h is already included via
> linux/syscalls.h but without the __SYSCALL definition.
> 
> So, a couple of questions:
> 
>   (1) Is the lack of header guards actually causing you a problem?
>   (2) How did you test this?
> 
> I've dropped the patch.
> 
> Will
> 
> 
Oh, my bad, sorry for that.

I found asm/unistd.h have no guard macro when I was migrate a userspace
program from x86_64 to arm64. The program uses the macro _ASM_X86_UNISTD_64_H,
but arm64 does not have this(arm has __ASM_ARM_UNISTD_H). So I tried to add
the guard macro.

Regards,
Yang


