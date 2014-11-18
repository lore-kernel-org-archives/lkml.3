Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaKRCXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:23:45 -0500
Received: from mail-pa0-f74.google.com ([209.85.220.74]:53403 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaKRCXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:23:42 -0500
References: <1414762838-13067-1-git-send-email-eternal.n08@gmail.com> <xr9361ed9rrj.fsf@gthelen.mtv.corp.google.com>
From: Greg Thelen <gthelen@google.com>
To: Junjie Mao <eternal.n08@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] x86, kaslr: Prevent .bss from overlaping initrd
In-reply-to: <xr9361ed9rrj.fsf@gthelen.mtv.corp.google.com>
Date: Mon, 17 Nov 2014 18:23:42 -0800
Message-ID: <xr934mtx9rgx.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Nov 17 2014, Greg Thelen wrote:
[...]
> Given that bss and brk are nobits (i.e. only ALLOC) sections, does
> file_offset make sense as a load address.  This fails with gold:
>
> $ git checkout v3.18-rc5
> $ make  # with gold
> [...]
> ..bss and .brk lack common file offset
> ..bss and .brk lack common file offset
> ..bss and .brk lack common file offset
> ..bss and .brk lack common file offset
>   MKPIGGY arch/x86/boot/compressed/piggy.S
> Usage: arch/x86/boot/compressed/mkpiggy compressed_file run_size
> make[2]: *** [arch/x86/boot/compressed/piggy.S] Error 1
> make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
> make: *** [bzImage] Error 2
[...]

I just saw http://www.spinics.net/lists/kernel/msg1869328.html which
fixes things for me.  Sorry for the noise.
