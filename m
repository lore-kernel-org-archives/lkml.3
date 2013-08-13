Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3HMEwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 00:52:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48283 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3HMEwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 00:52:04 -0400
Message-ID: <5209BB6F.2000208@codeaurora.org>
Date: Mon, 12 Aug 2013 21:51:59 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ARM ATTEND] catching up on exploit mitigations
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
In-Reply-To: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/2013 12:05 PM, Kees Cook wrote:
> I'd like to propose the topic of catching up to x86 exploit
> mitigations and security features, and potentially identifying
> ARM-unique mitigations/features that could be implemented. Several
> years ago, with Nicolas Pitre doing all the real work, I coordinated
> getting ARM caught up on things like userspace ASLR and
> stack-protector. Recently, based on work by Will Drewry, I ported
> seccomp-bpf to ARM. I'd like to continue this kind of thing, and I
> think it's overdue to examine this area again. A lot of work has
> already been done by grsecurity in this area (see
> http://forums.grsecurity.net/viewtopic.php?f=7&t=3292), so it would be
> good to start there.
>
> While it may expose my current ignorance of low level ARM mechanics,
> I'd like to examine and discuss:
>
> - RO and W^X kernel page table protections (similar to x86's
> DEBUG_RODATA and DEBUG_SET_MODULE_RONX; it's not clear to me how much
> LPAE and PXN is already handling this, if at all)
>

We've had support for RO/NX on our tree for a while. I'm interested in 
attending the summit to share what we've done and to see how much of it 
could be mainlined.

> - something like x86's SMEP and SMAP (to deter kernel exploitation
> from userspace)
>
> - vector table protections (needs to be protected like the x86_64
> vsyscall table, RO, etc)
>
> - kernel ASLR (I'm close to having this upstreamable for x86)
>
> - fuzzing (is anyone running trinity or similar on the ARM tree?)
>
> - any other things ... ?

I'd add getting something similar to CONFIG_ARCH_RANDOM for ARM. It 
wouldn't be a direct drop in to x86 but we have some usecases for a 
framework to hook into the arch_get_random_{int,long}. This is mostly 
useful for cases where we need random numbers before the kernel's 
entropy source is completely initialized. The last point is a separate 
discussion all together.

>
> Thanks,
>
> -Kees
>

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
