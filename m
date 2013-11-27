Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3K0RVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:21:35 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:59045 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3K0RVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:21:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131127112731.GA10435@gmail.com>
References: <20131126203727.GA352@www.outflux.net>
	<20131127112731.GA10435@gmail.com>
Date: Wed, 27 Nov 2013 09:21:33 -0800
X-Google-Sender-Auth: GTCjJP06ENWIuOeKqsOHCe8Xem8
Message-ID: <CAGXu5jLY+AzaB4f92OLA6Orm=Mr9C+G+-mgOmSf-yju+YCmaUg@mail.gmail.com>
Subject: Re: [PATCH v2] use -fstack-protector-strong
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olofj@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 3:27 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> On a defconfig x86_64 build (with CONFIG_CC_STACKPROTECTOR enabled), the
>> delta in size is just under 9% larger:
>>
>>  -rwxrwxr-x 1 kees kees  22134340 Nov 26 10:28 vmlinux.gcc-4.8
>>  -rwxrwxr-x 1 kees kees  22123870 Nov 26 10:40 vmlinux.gcc-4.9
>>  -rwxrwxr-x 1 kees kees  24225118 Nov 26 10:42 vmlinux.gcc-4.9+strong
>
> Please run it through 'size' so that we know the real text size
> increases.

   text    data     bss     dec     hex filename
11407474        1453792 1191936 14053202         d66f52 vmlinux.gcc-4.8
11458837        1457504 1191936 14108277         d74675 vmlinux.gcc-4.9
11682929        1457504 1191936 14332369         dab1d1 vmlinux.gcc-4.9+strong

Looks to be 2% for defconfig. That's way better. Shall I send a v3?

> If the cost of -fstack-protector-strong is really +9% in kernel text
> size then that's rather significant!
>
> If this option blows up our performance critical codepaths as well
> then this will likely cause a runtime slowdown as well, in addition to
> the increase in I$ footprint. That needs to be measured.
>
> CONFIG_CC_STACKPROTECTOR=y is relatively cheap today. For example on
> x86-64 defconfig:
>
>       text    data    bss     dec       filename
>   11378972    1455056 1191936 14025964  vmlinux  # CONFIG_CC_STACKPROTECTOR is not set
>   11420243    1455056 1191936 14067235  vmlinux  CONFIG_CC_STACKPROTECTOR=y
>
> that's a +0.3% cost currently.

Yeah -- not a lot of functions have char arrays. :)

>
> Thanks,
>
>         Ingo

-Kees

-- 
Kees Cook
Chrome OS Security
