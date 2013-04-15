Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008Ab3DOWiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:38:22 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33488 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DOWiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+KRVmZqSkvoEH70DCb055uSbVzFkoo+E1Ao=e=Yus_bA@mail.gmail.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-7-git-send-email-keescook@chromium.org>
	<CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com>
	<516A1D49.1050100@zytor.com>
	<CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com>
	<516C702C.2030209@zytor.com>
	<CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com>
	<516C751B.4020505@zytor.com>
	<CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com>
	<CAGXu5j+KRVmZqSkvoEH70DCb055uSbVzFkoo+E1Ao=e=Yus_bA@mail.gmail.com>
Date: Mon, 15 Apr 2013 15:38:20 -0700
X-Google-Sender-Auth: pRrD9v_ccX746JzTId1FIohj3dk
Message-ID: <CAE9FiQWosJRz14HgSq0cDYfsdSsMO9Vpbjd4f5UL3R6KHmOK5Q@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Northup <digitaleric@google.com>,
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

On Mon, Apr 15, 2013 at 3:07 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Apr 15, 2013 at 3:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> also do not overlap with boot_param, command_line, and initrd.
>>
>> and need to double check setup_header.init_size to make sure bss and
>> etc will not
>> fall into memory hole or reserved area in e820.
>>
>> also may need to setup page table for target position as bootloader may only
>> has ident mapping only for loaded bzImage 64 areas.
>>
>> looks you are trying redo the work for bootloader to pick loaded phys addr.
>
> aslr.S's select_aslr_address uses z_extract_offset as the upper bound.
>

so the decompressed image is not moved high?
