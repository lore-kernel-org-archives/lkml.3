Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3DOWAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:00:07 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46667 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3DOWAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:00:05 -0400
MIME-Version: 1.0
In-Reply-To: <516C751B.4020505@zytor.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-7-git-send-email-keescook@chromium.org>
	<CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com>
	<516A1D49.1050100@zytor.com>
	<CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com>
	<516C702C.2030209@zytor.com>
	<CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com>
	<516C751B.4020505@zytor.com>
Date: Mon, 15 Apr 2013 15:00:04 -0700
X-Google-Sender-Auth: BG8lpKkk9DyPsSVr15_bCy-3UMY
Message-ID: <CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Eric Northup <digitaleric@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 2:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/15/2013 02:41 PM, Kees Cook wrote:

> Please read what I wrote.
>
> The 2 GB limit is for the *virtual* mapping.
>
> The *physical* mapping, where it lands in RAM, is completely
> independent, and if you're going to randomize the latter, there is no
> reason it has to match the former.  Instead, randomize it freely.
>
> That is different from the i386 kernel which runs at its
> physical-mapping address.
>
> Incidentally, for performance reasons please avoid locating the kernel
> below CONFIG_PHYSICAL_ADDRESS if possible.
>
> Also make sure your code works with more than 128 e820 entries.

also do not overlap with boot_param, command_line, and initrd.

and need to double check setup_header.init_size to make sure bss and
etc will not
fall into memory hole or reserved area in e820.

also may need to setup page table for target position as bootloader may only
has ident mapping only for loaded bzImage 64 areas.

looks you are trying redo the work for bootloader to pick loaded phys addr.

Thanks

Yinghai
