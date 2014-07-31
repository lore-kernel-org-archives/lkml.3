Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaGaPw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:52:26 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54781 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaGaPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:52:25 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:781a:650a:7145:334d]
In-Reply-To: <20140731154803.GB26853@arm.com>
References: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
	<20140731103323.GL26853@arm.com>
	<CAOesGMiCiGwuGdOePPvE5WhZLRnG6qRvoJmBQHV4P9602Gy5DA@mail.gmail.com>
	<20140731154803.GB26853@arm.com>
Date: Thu, 31 Jul 2014 08:52:21 -0700
Message-ID: <CAOesGMjyYJCdJfFN7z8adUjHjaUh=7TgKvmUuf_pDZaHeskWpw@mail.gmail.com>
Subject: Re: [PATCH 0/4] LLVMLinux: Patches to enable the kernel to be
 compiled with clang/LLVM
From: Olof Johansson <olof@lixom.net>
To: Will Deacon <will.deacon@arm.com>
Cc: "behanw@converseincode.com" <behanw@converseincode.com>,
        "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "k.khlebnikov@samsung.com" <k.khlebnikov@samsung.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "takahiro.akashi@linaro.org" <takahiro.akashi@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 8:48 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Jul 31, 2014 at 04:39:55PM +0100, Olof Johansson wrote:
>> On Thu, Jul 31, 2014 at 3:33 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > On Thu, Jul 31, 2014 at 12:57:25AM +0100, behanw@converseincode.com wrote:
>> >> From: Behan Webster <behanw@converseincode.com>
>> >>
>> >> This patch set moves from using locally defined named registers to access the
>> >> stack pointer to using a globally defined named register. This allows the code
>> >> to work both with gcc and clang.
>> >>
>> >> The LLVMLinux project aims to fully build the Linux kernel using both gcc and
>> >> clang (the C front end for the LLVM compiler infrastructure project).
>> >>
>> >> Behan Webster (4):
>> >>   arm64: LLVMLinux: Add current_stack_pointer() for arm64
>> >>   arm64: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
>> >>   arm64: LLVMLinux: Calculate current_thread_info from
>> >>     current_stack_pointer
>> >>   arm64: LLVMLinux: Use current_stack_pointer in kernel/traps.c
>> >
>> > Once Andreas's comments have been addressed:
>> >
>> >   Acked-by: Will Deacon <will.deacon@arm.com>
>> >
>> > Please can you send a new series after the merge window?
>>
>> Given that the ARM64 KVM guys are still actively breaking -next, and
>> this is considerably smaller and lower risk than that, I think you can
>> take it for 3.17?
>
> Hey, those breakages are in the kvm tree not the arm64 tree! I'd really
> rather wait on these as I don't see the rush to get them in for 3.17 and
> it's not beyond the realms of possibility that they could cause problems
> for a particular version of GCC (at the very least, I'd need to re-run
> all the testing I've been doing).


Yeah, it was somewhat tongue in cheek that made not have made it
across the wire.

3.18 is fine with me too even though I find the concerns to be quite unlikely.


-Olof
