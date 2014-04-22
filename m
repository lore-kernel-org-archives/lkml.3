Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaDVLIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:08:35 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:50684 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbaDVLIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140422105744.GA589@arch.cereza>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-4-git-send-email-lftan@altera.com>
	<20140422105744.GA589@arch.cereza>
Date: Tue, 22 Apr 2014 19:08:20 +0800
X-Google-Sender-Auth: EWl0T_rtG2kE0FROvLUrg5Wb2to
Message-ID: <CAFiDJ5_sP+2XtD3BRAGGHCiSqiu4OCKBBYVzPpqCNfoJo5kFMg@mail.gmail.com>
Subject: Re: [PATCH 04/28] nios2: Exception handling
From: Ley Foon Tan <lftan@altera.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 6:57 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> Hi Ley Foon,
>
> Are you sure this is correct? Have you tested this works correctly?
>
> Last time I tested this, it caused the traced_system_call to be taken
> for every system call. I already reported and provided a patch a few
> months ago:
>
> http://lists.rocketboards.org/pipermail/nios2-dev/2014-January/006968.html
>
> Here's my proposed fix:
>
> diff --git a/arch/nios2/kernel/entry.S b/arch/nios2/kernel/entry.S
> index 9cf2bac..3798008 100644
> --- a/arch/nios2/kernel/entry.S
> +++ b/arch/nios2/kernel/entry.S
> @@ -204,13 +204,10 @@ ENTRY(handle_system_call)
>         ldw     r1, %lo(sys_call_table)(r1)
>         beq     r1, r0, ret_invsyscall
>
> -       /* Get thread info pointer */
> -       movi    r11, %lo(0xfffff000)
> -       and     r11, sp, r11
> -       ldw     r11, TI_FLAGS(r11)
> -
> -       /* If someone is ptrace:ing us, take the long way. */
> -       BTBNZ   r11, r11, TIF_SYSCALL_TRACE, traced_system_call
> +       /* Check if we are being traced */
> +       GET_THREAD_INFO r11
> +       ldw     r11,TI_FLAGS(r11)
> +       BTBNZ   r11,r11,TIF_SYSCALL_TRACE,traced_system_call
>
>         /* Execute the system call */
>         callr   r1
I think I missed out this in nios2-dev ML previously. I will take your fix.
Thanks.

Regards
