Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab3IBVaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:30:20 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42802 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723Ab3IBVaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:30:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvy+oBg-Qbd_8wL-86ODpB9fand2aVcyVcRRLarRe40wSw@mail.gmail.com>
References: <1378147630-12471-1-git-send-email-teg@jklm.no>
	<CAFLxGvy+oBg-Qbd_8wL-86ODpB9fand2aVcyVcRRLarRe40wSw@mail.gmail.com>
Date: Mon, 2 Sep 2013 23:30:17 +0200
X-Google-Sender-Auth: wtCAeYzuyuXys4NpH8Kj3G9ab5g
Message-ID: <CAMuHMdU1Dt2KOJny78d2DdprHwF5cOQEMGDm7rVDMRyL1jTAsA@mail.gmail.com>
Subject: Re: [PATCH] input: allow SERIO=m even without EXPERT=y
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Tom Gundersen <teg@jklm.no>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 11:01 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Mon, Sep 2, 2013 at 8:47 PM, Tom Gundersen <teg@jklm.no> wrote:
>> There is plenty of consumer hardware (e.g., mac books) that does not use
>> AT keyboards or PS/2 mice. It therefore makes sense for distro kernels
>> to build the related drivers as modules to avoid loading them on hardware
>> that does not need them. As such, these options should no longer be protected
>> by EXPERT.
>>
>> Moreover, building these drivers as modules gets rid of the following ugly
>> error during boot:
>>
>> [    2.337745] i8042: PNP: No PS/2 controller found. Probing ports directly.
>> [    3.439537] i8042: No controller found
>>
>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> ---
>>  drivers/input/keyboard/Kconfig | 4 ++--
>>  drivers/input/serio/Kconfig    | 6 +++---
>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
>> index 269d4c3..2d31cec 100644
>> --- a/drivers/input/keyboard/Kconfig
>> +++ b/drivers/input/keyboard/Kconfig
>> @@ -2,7 +2,7 @@
>>  # Input core configuration
>>  #
>>  menuconfig INPUT_KEYBOARD
>> -       bool "Keyboards" if EXPERT || !X86
>> +       bool "Keyboards"
>
> Maybe this a stupid question, but why are you dropping the "!X86" too?

Because the "if EXPERT" only mattered for X86.

Apply De Morgan and it read like "do not ask the question if !EXPERT && X86".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
