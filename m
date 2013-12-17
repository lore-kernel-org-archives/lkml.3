Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3LQA5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:57:10 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:59417 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3LQA5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:57:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+6_M65pDoJjx1NEUw8SkfpGjH=yhswt-RW=_W97=kkzQ@mail.gmail.com>
References: <20131126203727.GA352@www.outflux.net>
	<20131127112731.GA10435@gmail.com>
	<CAGXu5jLY+AzaB4f92OLA6Orm=Mr9C+G+-mgOmSf-yju+YCmaUg@mail.gmail.com>
	<20131127175442.GA28088@gmail.com>
	<52963223.9080701@zytor.com>
	<CAGXu5j+6_M65pDoJjx1NEUw8SkfpGjH=yhswt-RW=_W97=kkzQ@mail.gmail.com>
Date: Mon, 16 Dec 2013 16:57:08 -0800
X-Google-Sender-Auth: ckf1SO812-sVmyh-nzda-OWsa18
Message-ID: <CAGXu5j+0gjN118RijCinw31g51BZez_oGKFYJwq2T3=yojG_ww@mail.gmail.com>
Subject: Re: [PATCH v2] use -fstack-protector-strong
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olofj@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 10:11 AM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Nov 27, 2013 at 9:55 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/27/2013 09:54 AM, Ingo Molnar wrote:
>>>>
>>>> Looks to be 2% for defconfig. That's way better. Shall I send a v3?
>>>
>>> Well, it's better than 9%, but still almost an order of magnitude
>>> higher than the cost is today, and a lot of distros have
>>> CONFIG_CC_STACKPROTECTOR=y.
>>>
>>> So it would be nice to measure how much the instruction count goes up
>>> in some realistic system-bound test. How much does something like
>>> kernel/built-in.o increase, as per 'size' output?
>
>    text    data     bss     dec     hex filename
>  929611   90851  594496 1614958  18a46e built-in.o-gcc-4.9
>  954648   90851  594496 1639995  19063b built-in.o-gcc-4.9+strong
>
> Looks like 3% for defconfg + CONFIG_CC_STACKPROTECTOR
>
>>
>> Do we need CONFIG_CC_STACKPROTECTOR_STRONG?
>
> I'm hoping to avoid this since nearly anyone using CC_STACKPROTECTOR
> would want strong added, but as a fallback, I'm happy to implement it
> as a separate config item.

Any verdict on this? Should I go with adding ..._STRONG like we used
to have for ..._ALL, or is defaulting to -strong best?

-Kees

-- 
Kees Cook
Chrome OS Security
