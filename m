Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaDURwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:52:45 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:43535 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaDURwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:52:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAFiDJ5-e=vRLxyKuzSQO0vg4HBHessv3xE9SdCQ9zFOqYOreZg@mail.gmail.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-13-git-send-email-lftan@altera.com>
	<20140419160947.GA27776@amd.pavel.ucw.cz>
	<CAFiDJ5-e=vRLxyKuzSQO0vg4HBHessv3xE9SdCQ9zFOqYOreZg@mail.gmail.com>
Date: Mon, 21 Apr 2014 19:52:38 +0200
Message-ID: <CAFLxGvxXfJNKK=n5tSkjt=zjBT-Auo2mCMf7PQr5skOVxYeW+w@mail.gmail.com>
Subject: Re: [PATCH 16/28] nios2: System calls handling
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: Pavel Machek <pavel@denx.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 7:32 PM, Ley Foon Tan <lftan@altera.com> wrote:
> On Sun, Apr 20, 2014 at 12:09 AM, Pavel Machek <pavel@denx.de> wrote:
>>> +/* Additional Nios II specific syscalls. */
>>> +#define __NR_cacheflush (__NR_arch_specific_syscall)
>>> +__SYSCALL(__NR_cacheflush, sys_cacheflush)
>>
>> I guess you should Cc: Michael Kerrisk on this one.
> CC him this email.
>
>>
>> Also... explanation why you need this syscall while other
>> architectures live happily without it would be nice.
> This syscall exist in nios2 port since old days and some users already
> used it for sometimes.
> Like mentioned by Greet, 12 our of 28 architectures provide such a syscall.
>
>>> +/* sys_cacheflush -- flush the processor cache. */
>>> +asmlinkage int sys_cacheflush(unsigned long addr, unsigned long len,
>>> +                             unsigned int op)
>>> +{
>>> +     struct vm_area_struct *vma;
>>> +
>>> +     if (len == 0)
>>> +             return 0;
>>
>> op is being ignored? You should remove it... or if (op) return -EINVAL
>> if you want future extensions.
> Yes, op argument is being ignored. Okay, will add the return -EINVAL
> if op is non-zero.

Be careful. If existing applications already use this and maybe pass a
dummy value
to it you break them.

-- 
Thanks,
//richard
