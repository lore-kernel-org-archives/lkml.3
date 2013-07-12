Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab3GLWnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:43:12 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36837 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab3GLWnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <51E082F6.4030305@zytor.com>
References: <20130712183014.GA20551@www.outflux.net>
	<51E082F6.4030305@zytor.com>
Date: Fri, 12 Jul 2013 15:43:10 -0700
X-Google-Sender-Auth: Xa-5XqVSEKn2J5M6Cn5tllIPjMQ
Message-ID: <CAGXu5jJ_eo3AP67jS8M1mPak-SxS4FzBoosJTzj5cb=CLC43KQ@mail.gmail.com>
Subject: Re: [PATCH] x86: make sure IDT is page aligned
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Seiji Aguchi <seiji.aguchi@hds.com>,
        PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That was the busted patch. See the v2 I sent. Only 64-bit needs
alignment. And after looking more at it, the idt in head_64.S could be
entirely dropped in favor of using the one in arch/x86/kernel/traps.c
(after moving it out of the #ifdef.

-Kees

On Fri, Jul 12, 2013 at 3:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/12/2013 11:30 AM, Kees Cook wrote:
>>
>> -     .word 0                         # 32-bit align idt_desc.address
>> +     .word PAGE_SIZE                 # page align idt_desc.address
>>
>
> ... and this is totally confused.  This didn't change alignment one
> iota, it only put the value 4096 into the padding.
>
>         -hpa
>



-- 
Kees Cook
Chrome OS Security
