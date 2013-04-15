Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3DOV7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:59:12 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:38728 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3DOV7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:59:10 -0400
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
Date: Mon, 15 Apr 2013 14:59:09 -0700
X-Google-Sender-Auth: 6Jv-RpKcowLJD4qmKBVvri3Erik
Message-ID: <CAGXu5jJvGx=5YV3mw6DTO75HwO_Yn_vbTN2GkkZr-CiqJqw=_g@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Northup <digitaleric@google.com>, Yinghai Lu <yinghai@kernel.org>,
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
>>>
>>> You seem to be missing something here...
>>>
>>> There are *two* mappings in 64-bit mode.  Physically, if you're going to
>>> randomize you might as well randomize over the entire range... except
>>> not too far down (on either 32 or 64 bit mode)... in particular, you
>>> don't want to drop below 16 MiB if you can avoid it.
>>>
>>> On 64 bits, there is no reason the virtual address has to be randomized
>>> the same way.
>>
>> Aren't we bound by the negative 2GB addressing due to -mcmodel=kernel?
>>
>
> Guys,
>
> Please read what I wrote.
>
> The 2 GB limit is for the *virtual* mapping.
>
> The *physical* mapping, where it lands in RAM, is completely
> independent, and if you're going to randomize the latter, there is no
> reason it has to match the former.  Instead, randomize it freely.

Ah, gotcha. I don't see much benefit in doing this as it would make
the 32-bit and 64-bit logic pretty different without much real-world
gain, IMO.

> That is different from the i386 kernel which runs at its
> physical-mapping address.
>
> Incidentally, for performance reasons please avoid locating the kernel
> below CONFIG_PHYSICAL_ADDRESS if possible.

You mean CONFIG_PHYSICAL_START? This is already done in aslr.S via
LOAD_PHYSICAL_ADDR which is calculated from the
CONFIG_PHYSICAL_ALIGN-masked CONFIG_PHYSICAL_START.

> Also make sure your code works with more than 128 e820 entries.

There should be no problem here; we're using edi to count them.

-Kees

--
Kees Cook
Chrome OS Security
