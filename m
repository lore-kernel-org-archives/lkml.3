Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaDURcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:32:22 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:52109 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaDURcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:32:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140419160947.GA27776@amd.pavel.ucw.cz>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-13-git-send-email-lftan@altera.com>
	<20140419160947.GA27776@amd.pavel.ucw.cz>
Date: Tue, 22 Apr 2014 01:32:15 +0800
X-Google-Sender-Auth: 3maNBLwUBo6W2VA4LYnH93Fhn3I
Message-ID: <CAFiDJ5-e=vRLxyKuzSQO0vg4HBHessv3xE9SdCQ9zFOqYOreZg@mail.gmail.com>
Subject: Re: [PATCH 16/28] nios2: System calls handling
From: Ley Foon Tan <lftan@altera.com>
To: Pavel Machek <pavel@denx.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cltang@codesourcery.com,
        mtk.manpages@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 12:09 AM, Pavel Machek <pavel@denx.de> wrote:
>> +/* Additional Nios II specific syscalls. */
>> +#define __NR_cacheflush (__NR_arch_specific_syscall)
>> +__SYSCALL(__NR_cacheflush, sys_cacheflush)
>
> I guess you should Cc: Michael Kerrisk on this one.
CC him this email.

>
> Also... explanation why you need this syscall while other
> architectures live happily without it would be nice.
This syscall exist in nios2 port since old days and some users already
used it for sometimes.
Like mentioned by Greet, 12 our of 28 architectures provide such a syscall.

>> +/* sys_cacheflush -- flush the processor cache. */
>> +asmlinkage int sys_cacheflush(unsigned long addr, unsigned long len,
>> +                             unsigned int op)
>> +{
>> +     struct vm_area_struct *vma;
>> +
>> +     if (len == 0)
>> +             return 0;
>
> op is being ignored? You should remove it... or if (op) return -EINVAL
> if you want future extensions.
Yes, op argument is being ignored. Okay, will add the return -EINVAL
if op is non-zero.

Thanks.

Regards
Ley Foon
