Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaKLLHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:07:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41044 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaKLLHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:07:09 -0500
Message-ID: <54633F53.8020507@linaro.org>
Date: Wed, 12 Nov 2014 20:06:59 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Oleg Nesterov <oleg@redhat.com>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <20141107140405.GA30156@redhat.com> <54633A69.6090202@linaro.org> <20141112110047.GB26437@arm.com>
In-Reply-To: <20141112110047.GB26437@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 08:00 PM, Will Deacon wrote:
> On Wed, Nov 12, 2014 at 10:46:01AM +0000, AKASHI Takahiro wrote:
>> On 11/07/2014 11:04 PM, Oleg Nesterov wrote:
>>> To me the fact that PTRACE_SET_SYSCALL can be undefined and syscall_set_nr()
>>> is very much arch-dependant (but most probably trivial) means that this  code
>>> should live in arch_ptrace().
>>
>> Thinking of Oleg's comment above, it doesn't make sense neither to define generic
>> NT_SYSTEM_CALL (user_regset) in uapi/linux/elf.h and implement it in ptrace_regset()
>> in kernel/ptrace.c with arch-defined syscall_(g)set_nr().
>>
>> Since we should have the same interface on arm and arm64, we'd better implement
>> ptrace(PTRACE_SET_SYSCALL) locally on arm64 for now (as I originally submitted).
>
> I think the regset approach is cleaner. We already do something similar for
> TLS. That would be implemented under arch/arm64/ with it's own NT type.

Okey, so arm64 goes its own way :)
Or do you want to have a similar regset on arm, too?
(In this case, NT_ARM_SYSTEM_CALL can be shared in uapi/linux/elf.h)

-Takahiro AKASHI

> Will
>
